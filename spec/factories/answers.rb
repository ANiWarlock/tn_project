FactoryGirl.define do
  sequence :body do |n|
    "Answer N #{n}"
  end

  factory :answer do
    body
    question
    user
  end

  factory :invalid_answer, class: "answer" do
    title nil
    body nil
    user
  end
end
