FactoryBot.define do
  factory :article do
    title { "John" }
    content  { "Doe"}
    tags { ['Js', 'Vuejs'] }
  end
end
