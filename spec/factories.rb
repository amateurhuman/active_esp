FactoryGirl.define do
  factory :subscriber, :class => ActiveESP::Subscriber do
    first_name        "Billie Joe"
    last_name         "Armstrong"
    sequence(:email)  { |n| "kerplunk#{n}@example.com" }
  end
end