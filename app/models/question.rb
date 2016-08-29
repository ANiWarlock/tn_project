class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  validates :title, :body, :user_id, presence: true
  validates :best_answer, :length => { :maximum => 1 } #???

  def best_answer
    @best_answer ||= self.answers.find_by(best: true)
  end
end
