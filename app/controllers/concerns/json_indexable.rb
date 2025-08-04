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
    records = records.order(id: :desc)
    page = params[:page].present? ? params[:page].to_i : 1
    size = params[:size].present? ? params[:size].to_i : 5
    pagy, items = pagy(records, page: page, limit: size)
    render json: { data: blueprint_class.render_as_hash(items), totalCount: pagy.count }
  end
end