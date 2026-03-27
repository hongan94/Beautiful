module JsonIndexable
  extend ActiveSupport::Concern

  private

  # You can pass a block to customize the base query, e.g.:
  # handle_json_index('Manager', ManagerBlueprint) { |model| model.active }
  def handle_json_index(model_class, blueprint_class)
    model = model_class.constantize
    # Allow custom base query via block, fallback to .all
    base_query = if block_given?
      yield(model)
    else
      model.all
    end

    # Eager load avatar if present
    records = if model.reflect_on_association(:avatar_url_attachment)
      base_query.includes(avatar_url_attachment: :blob)
    else
      base_query
    end

    records = records.filter_records(params) if model.respond_to?(:filter_records)

    page = params[:page].present? ? params[:page].to_i : 1
    size = params[:size].present? ? params[:size].to_i : 50
    pagy_vars = { page: page, limit: size }
    is_searchkick = records.is_a?(Searchkick::Results) || 
                    (defined?(Searchkick::Relation) && records.is_a?(Searchkick::Relation)) || 
                    records.class.name.include?('Searchkick') ||
                    (records.is_a?(Array) && records.first.respond_to?(:searchkick_index))
    
    if is_searchkick
      pagy, items = pagy_searchkick(records, **pagy_vars)
    else
      records = records.order(id: :desc) if records.respond_to?(:order)
      pagy, items = pagy(records, **pagy_vars)
    end
    render json: { data: blueprint_class.render_as_hash(items.to_a), totalCount: pagy.count }
  end
end