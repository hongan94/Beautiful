module Queryable
  extend ActiveSupport::Concern

  included do
    # You can specify which columns to search if ES is disabled
    class_attribute :searchable_columns, default: [:name, :title, :email_address]
  end

  class_methods do
    def use_elasticsearch?
      ENV['USE_ELASTICSEARCH'] == 'true'
    end

    def filter_records(params)
      return all if params[:search].blank?

      if use_elasticsearch?
        begin
          # Searchkick logic
          # We assume searchkick is extended in the model
          if respond_to?(:pagy_search)
            return pagy_search(params[:search], where: search_filters(params))
          else
            return search(params[:search])
          end
        rescue => e
          Rails.logger.error "Elasticsearch error, falling back to database search: #{e.message}"
        end
      end

      # Database fallback (ILIKE) or if ES search failed
      fallback_search(params[:search], params)
    end

    private

    def search_filters(params)
      # Override this in model if you need specific filters (e.g. status: 'active')
      {}
    end

    def fallback_search(query, params)
      search_term = "%#{query}%"
      conditions = searchable_columns.map do |col|
        "#{col} ILIKE :q" if column_names.include?(col.to_s)
      end.compact.join(' OR ')

      if conditions.present?
        where(conditions, q: search_term)
      else
        all
      end
    end
  end
end
