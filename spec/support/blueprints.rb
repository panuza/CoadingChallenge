require 'machinist/active_record'

User.blueprint do
  email { "email@test.com#{ sn }" }
  password { "123456789" }
  password_confirmation { "123456789" }
  first_name { "panuza" }
  last_name { "parajuli#{ sn }" }
end

Challenge.blueprint do
  name { "test challenge#{ sn }" }
  description { "Description of challenge" }
  question { "What is your name?" }
  difficulty_level { 1 }
  category { "Sports" }
end
