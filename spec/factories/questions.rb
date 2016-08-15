FactoryGirl.define do
  sequence :title do |n|
    "Question N #{n} title"
  end

  factory :question do
    title
    body "MyText"
  end

  factory :invalid_question, class: "question" do
    title nil
    body nil
  end
end
