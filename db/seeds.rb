# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

["Alice", "Bob"].each_with_index do |name, project|
  ["'s Adventures in Wonderland", " the Builder"].each do |title|
    Article.create(title: name + title, body: "This is the body of the article", is_public: true, project: project)
  end
  ["'s Secret Thoughts", "'s Private Diary"].each do |title|
    Article.create(title: name + title, body: "This is the body of the article", is_public: false, project: project)
  end
end