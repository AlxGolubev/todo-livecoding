# spec/factories/item.rb

FactoryBot.define do
  factory :item do
    title  { FFaker::Food.fruit }
    completed { false }

    trait :completed do
      completed { true }
    end
  end
end
