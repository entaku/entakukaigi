def r_str
  SecureRandom.hex(3)
end

FactoryGirl.define do

  sequence :name do |n|
    "#{Faker::Address.city}-#{n}#{r_str}"
  end

  sequence :email do |n|
    "oo-#{n}#{r_str}@example.net"
  end

  sequence :uid do |n|
    "#{n}#{Time.now.to_i}"
  end

  sequence :fb_id do |n|
    Time.now.to_i
  end

  sequence :username do |n|
    "#{Faker::Name.name}-#{n}"
  end

  sequence :first_name do |n|
   Faker::Name.first_name
  end

  sequence :last_name do |n|
    Faker::Name.last_name
  end

  sequence :displayname do |n|
    Faker::Name.first_name + Faker::Name.last_name
  end

  sequence :dob do |n|
    22.years.ago
  end

  sequence :key do |n|
    "#{Time.now.to_i}"
  end

  sequence :value do |n|
    Faker::Lorem.sentence
  end

end