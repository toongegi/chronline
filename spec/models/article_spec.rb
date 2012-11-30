# == Schema Information
#
# Table name: articles
#
#  id         :integer          not null, primary key
#  body       :text
#  subtitle   :string(255)
#  taxonomy   :string(255)
#  teaser     :string(255)
#  title      :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'spec_helper'

describe Article do

  before do
    @article = Article.new(title: 'Ash defeats Gary in Indigo Plateau',
                           subtitle: 'Oak arrives just in time',
                           teaser: 'Ash becomes new Pokemon champion',
                           body: '**Pikachu** wrecks everyone. The End.',
                           taxonomy: 'news/',
                           )
  end

  subject { @article }

  it { should be_valid }

  describe "when body is not present" do
    before { @article.body = "" }
    it { should_not be_valid }
  end

  describe "when title is not present" do
    before { @article.title = "" }
    it { should_not be_valid }
  end

end
