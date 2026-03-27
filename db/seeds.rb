# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
puts "Seeding UserGroups and Permissions..."

modules = %w[User Manager UserGroup SystemConfig Dashboard]
actions = %w[create read update delete import export]

modules.each do |subject_class|
  actions.each do |action|
    # Only allow 'read' for Dashboard
    next if subject_class == "Dashboard" && action != "read"
    
    Permission.find_or_create_by!(
      subject_class: subject_class,
      action: action
    ) do |p|
      p.description = "Allow #{action} on #{subject_class}"
    end
  end
end

if UserGroup.count.zero?
  admin_group = UserGroup.create!(name: "Super Admin", description: "Administrator with all permissions")
  admin_group.permissions = Permission.all

  editor_group = UserGroup.create!(name: "Content Editor", description: "Can manage content but not configuration")
  editor_group.permissions = Permission.where.not(subject_class: ["SystemConfig", "UserGroup"])
end

puts "Permissions and UserGroups seeded successfully."
50.times do |i|
  email = "yuna#{i}@example.com"
  User.find_or_create_by!(email_address: email) do |user|
    user.first_name = "John"
    user.last_name = "Doe"
    user.phone_number = "+1234567890"
    user.password = "password"
    user.password_confirmation = "password"
    user.role = "admin"
    user.status = "active"
  end
end
