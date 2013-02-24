class Admin::ArticlesController < Admin::BaseController

  def index
    taxonomy_string = "/#{params[:section]}/" if params[:section]
    @taxonomy = Taxonomy.new(taxonomy_string)

    if params[:date] and not params[:page]
      date = Date.parse(params[:date]) + 1
      params[:page] = find_article_page_for_date(date, @taxonomy)
    end

    @articles = Article.includes(:authors, :image)
      .section(@taxonomy)
      .order('created_at DESC')
      .page(params[:page])
  end

  def new
    @article = Article.new
  end

  def create
    @article = update_article(Article.new)
    if @article.save
      redirect_to site_article_url(@article, subdomain: 'www')
    else
      render 'new'
    end
  end

  def edit
    @article = Article.find(params[:id])
    if request.path != edit_admin_article_path(@article)
      redirect_to [:edit, :admin, @article], status: :moved_permanently
    end
  end

  def publish
    @article = Article.find(params[:id])
    @article.published_at = DateTime.now
    if @article.save
      flash[:sucess] = %Q[Article "#{@article.title} was published."]
    else 
      flash[:notice] = %Q[Article "#{@article.title} was not published."]
    end 
    redirect_to :back  
  end

  def update
    @article = update_article(Article.find(params[:id]))
    if @article.save
      redirect_to site_article_url(@article, subdomain: 'www')
    else
      render 'edit'
    end
  end

  def destroy
    article = Article.find(params[:id])
    article.destroy
    flash[:success] = %Q[Article "#{article.title}" was deleted.]
    redirect_to admin_articles_path
  end

  def search
    if params.has_key? :article_search
      @article_search = Article::Search.new(params[:article_search])
      @article_search.page = params[:page] if params.has_key? :page
      @articles = @article_search.results
    else
      @article_search = Article::Search.new
      @articles = []
    end
  end

  private

  def update_article(article)
    # Last element of taxonomy array may be an empty string
    params[:article][:section].pop if params[:article][:section].last.blank?
    author_names = params[:article].delete(:author_ids).reject {|s| s.blank? }
    article.assign_attributes(params[:article])
    article.authors = Staff.find_or_create_all_by_name(author_names)
    article
  end

  def find_article_page_for_date(date, taxonomy)
    index = Article.section(taxonomy)
      .where(["created_at > ?", date]).count
    index / Article.per_page + 1
  end

end
