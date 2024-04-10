class ArticlesController < ApplicationController
  def index
    @articles = Article.where($oso.list_local(current_user, 'view', 'Article', 'id'))
                      .order(:created_at)
                      .limit(10)
  end
end
