class Admin::ArticlesController < ApplicationController
  before_action :set_article, only: [:edit, :update, :destroy]

  def index
    @articles = Article.order(created_at: :desc)
  end

  def new
    @article = Article.new
    @article.build_seo_meta
  end

  def edit
    @article.build_seo_meta unless @article.seo_meta
  end

  def create
    @article = current_user.articles.build(article_params)
    if @article.save
      redirect_to admin_articles_path, notice: "Article was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @article.update(article_params)
      redirect_to admin_articles_path, notice: "Article was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @article.destroy
    redirect_to admin_articles_path, notice: "Article was successfully deleted."
  end

  private

  def set_article
    @article = Article.find(params[:id])
  end

  def article_params
    params.require(:article).permit(:title, :slug, :excerpt, :content, :status, :published_at, :category_id, :cover_image, tag_ids: [], seo_meta_attributes: [:id, :meta_title, :meta_description, :meta_keywords, :og_image])
  end
end
