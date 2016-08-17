FactoryGirl.define do
  factory :answer do
    body "MyText"
    question
    user
  end

  factory :invalid_answer, class: "answer" do
    title nil
    body nil
    user
  end
end
