class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  has_many :attachments, as: :attachable

  validates :title, :body, :user_id, presence: true
  #validates :best_answer, :length => { :maximum => 1 } #???

  accepts_nested_attributes_for :attachments


  def best_answer
    @best_answer ||= self.answers.find_by(best: true)
  end
end
