FactoryGirl.define do
  sequence :title do |n|
    "Question N #{n} title"
  end

  factory :question do
    title
    body "MyText"
    user

    trait :with_answers do
      after(:create) do |question|
        create_list :answer, 2, question: question
      end
    end
  end

  factory :invalid_question, class: "question" do
    title nil
    body nil
    user
  end
end
