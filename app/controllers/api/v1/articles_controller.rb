class Api::V1::ArticlesController < ApplicationController
  before_action :article, only: [:show, :update, :destroy]
  before_action :authenticate_user!, only: [:create, :update, :destroy]

  # GET /api/v2/articles
  def index
    @per =  params[:per].try(:to_i) || 15
    @page = params[:page].try(:to_i) || 0
    @search = params[:search]
    @articles = paginated_articles(@search, @page, @per)

    nb_pages = @per ? nb_pages(@search, @per) : nil
    meta = {
      page: @page,
      per: @per,
      nb_pages: nb_pages,
      search: params[:search]
    }

    render json: {
      articles: @articles,
      meta: meta
    }
  end

  def show
    render json: @article
  end

  # POST /api/v2/power/article
  def create
    @article = Article.new(article_params)

    if @article.save
      render json: @article, status: :created
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # PATCH/PUT /api/v2/power/articles/1
  def update
    if @article.update(article_params)
      render json: @article
    else
      render json: @article.errors, status: :unprocessable_entity
    end
  end

  # DELETE /api/v1/article/1
  def destroy
    @article.destroy
  end

  private

  def articles(search)
    if search
      ::Article.where('title ILIKE :search OR content ILIKE :search', search: "%#{params[:search]}%")
    else
      ::Article.all
    end
  end

  def paginated_articles(search, page, per)
    result = articles(search)
    result = result.offset(page * per).limit(per) if per
    result
  end

  def nb_pages(search, per)
    articles = articles(search)
    (articles.count.to_f / per).ceil
  end

  # Use callbacks to share common setup or constraints between actions.
  def article
    @article = Article.find(params[:id])
  end

  # Only allow a trusted parameter "white list" through.
  def article_params
    params.require(:article).permit(
      :title,
      :content,
      :tags
    )
  end
end
