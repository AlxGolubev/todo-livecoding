FactoryBot.define do
  factory :list do
    association :user

    title { FFaker::Book.title }
    body { FFaker::Book.description }
  end
end
