module Api
  module V1
    class ArticlesController < BaseController
      include JsonIndexable
      skip_before_action :verify_authenticity_token
      
      def index
        # Phục vụ public API cho Frontend (React/Nextjs) lấy danh sách bài viết
        # Chỉ lấy những bài đã publish
        base_query = ->(model) { model.where(status: 'published').order(published_at: :desc) }
        
        # Hàm xử lý trong module
        handle_json_index(Article.to_s, ArticleBlueprint, &base_query)
      end

      def show
        article = Article.friendly.find(params[:id]) || Article.find_by!(slug: params[:id])
        
        if article.published? || Current.user&.admin?
          render json: ArticleBlueprint.render(article, view: :detail)
        else
          render json: { error: "Not Found" }, status: :not_found
        end
      end
    end
  end
end
