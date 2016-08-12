FactoryGirl.define do
  factory :answer do
    body "MyText"
    question_id 1
  end

  factory :invalid_answer, class: "answer" do
    title nil
    body nil
  end
end
