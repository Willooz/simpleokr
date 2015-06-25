# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

3.times do
  okr = Okr.create(
    admin_name: Faker::Name.name,
    admin_email: Faker::Internet.email,
    owner: Faker::Name.title,
    period: Faker::Date.forward(100),
    public_url: SecureRandom.hex(10),
    admin_url: SecureRandom.hex(16)
    )
  3.times do
    obj = okr.objectives.create(description: Faker::Lorem.paragraph(2, false, 2))
    3.times do
      obj.key_results.create(description: Faker::Lorem.paragraph(2, false, 2))
    end
  end
end