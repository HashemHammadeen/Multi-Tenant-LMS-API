# Clear existing data to avoid duplication errors during testing
puts "Cleaning database..."
Enrollment.destroy_all
Course.destroy_all
User.destroy_all
School.destroy_all

puts "Creating Schools..."
schools = []
["school1", "school2"].each do |subdomain|
  schools << School.create!(
    name: "#{subdomain.capitalize} Academy",
    subdomain: subdomain,
    active: true
  )
end

schools.each do |school|
  puts "Populating #{school.name}..."

  # Set Current.school so default_scopes (Phase 3) and validations work correctly
  # if you have logic that depends on the current tenant during creation.
  Current.school = school

  # 1. Create Users (3 per role)
  roles = ['user', 'instructor', 'admin']

  roles.each do |role_name|
    3.times do |i|
      User.create!(
        name: "#{role_name.capitalize} #{i+1} (#{school.subdomain})",
        email: "#{role_name}#{i+1}@#{school.subdomain}.com",
        password: "password123", # Standard password for easy testing
        role: role_name,
        school: school,
        active: true
      )
    end
  end

  # 2. Create Courses (3 per school)
  courses = []
  3.times do |i|
    courses << Course.create!(
      title: "Course #{i+1} - #{school.name}",
      description: "Learn the fundamentals of subject #{i+1} at #{school.name}.",
      school: school
    )
  end

  # 3. Create Sample Enrollments
  # Let's enroll the first 'user' of each school into the first two courses of that school
  student = User.find_by(email: "user1@#{school.subdomain}.com")

  Enrollment.create!(user: student, course: courses[0], school: school)
  Enrollment.create!(user: student, course: courses[1], school: school)

  # Enroll the second 'user' into the third course
  student2 = User.find_by(email: "user2@#{school.subdomain}.com")
  Enrollment.create!(user: student2, course: courses[2], school: school)
end

# Reset Current context after seeding
Current.school = nil

puts "✅ Seeding Complete!"
puts "-------------------------------------------------------"
puts "Total Schools: #{School.count}"
puts "Total Users:   #{User.count} (9 per school)"
puts "Total Courses: #{Course.count} (3 per school)"
puts "Total Enrolls: #{Enrollment.count}"
puts "-------------------------------------------------------"
puts "Test Login: user1@school1.com / password123"