class Manager < User
  default_scope { where(role: :admin) }

  before_validation :set_admin_role

  # Map sortField (which is the index of the column header) to the actual column name
  def self.filter_records(params)
    # Define the mapping from index to column name
    # Adjust this array to match the order of your table headers
    columns = [
      'id',           # 0
      'name',         # 1 (special handling below)
      'phone_number', # 2
      'gender',       # 3
      'address',      # 4
      'status',       # 5
      'created_at'    # 6
      # Add more columns if needed
    ]

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
      sort_index = params[:sortField].to_i
      sort_column = columns[sort_index] rescue nil
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

    records
  end

  private

  def set_admin_role
    self.role = :admin
  end
end
