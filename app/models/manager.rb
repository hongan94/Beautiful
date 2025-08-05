class Manager < User
  default_scope { where(role: :admin) }

  before_validation :set_admin_role

  # Map sortField (which is the index of the column header) to the actual column name
  def self.filter_records(params)
    records = all

    # Filter by name or email if search param is present
    if params[:search].present?
      search_term = params[:search].to_s.strip
      records = records.where(
        "(first_name || ' ' || last_name) ILIKE :q OR email_address ILIKE :q",
        q: "%#{search_term}%"
      )
    end

    if params[:sortField].present? && params[:sortOrder].present?
      sort_column = params[:sortField]
      sort_order = params[:sortOrder].downcase

      if sort_column.present? && %w[asc desc].include?(sort_order)
        if sort_column == 'name'
          # Sort by first_name then last_name
          records = records.order("(first_name || ' ' || last_name) #{sort_order}")
        else
          records = records.order("#{sort_column} #{sort_order}")
        end
      end
    end

    # INSERT_YOUR_CODE
    # Handle filters param (expects JSON array of {column, value})
    if params[:filters].present?
      begin
        filters = params[:filters]
        # Accept both JSON string and array
        filters = JSON.parse(filters) if filters.is_a?(String)
        filters.each do |filter|
          column = filter['column'] || filter[:column]
          value = filter['value'] || filter[:value]
          next if value.blank?

          case column
          when 'status'
            records = records.where(status: value)
          when 'sort_by'
            # Custom sort_by logic
            if value == 'latest'
              records = records.reorder(created_at: :desc)
            elsif value == 'oldest'
              records = records.reorder(created_at: :asc)
            end
          # Add more filter columns as needed
          else
            # Generic filter for other columns
            if records.column_names.include?(column.to_s)
              records = records.where(column => value)
            end
          end
        end
      rescue JSON::ParserError
        # Ignore filter if not valid JSON
      end
    end
    records
  end

  private

  def set_admin_role
    self.role = :admin
  end
end
