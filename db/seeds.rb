# frozen_string_literal: true

def create_admin_user
  user = User.find_or_create_by(email: "admin@admin.com", name: "Admin")
  user.update(password: "password", password_confirmation: "password")
  user.save!
  user
end

def create_user_posts(user)
  (1..200).each do |number|
    Post.create(
      title: "#{ActiveSupport::Inflector.ordinalize(number)} Post",
      content: Faker::Lorem.paragraphs(number: rand(5..100)),
      user:
    )
  end
end

user = create_admin_user
create_user_posts(user)
