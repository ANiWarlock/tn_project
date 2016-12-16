class Answer < ApplicationRecord
  belongs_to :question
  belongs_to :user
  has_many :attachments, as: :attachable
  validates :body, :question_id, :user_id, presence: true

  accepts_nested_attributes_for :attachments, reject_if: :all_blank

  default_scope { order(best: :desc, created_at: :asc )}

  def set_best
    unless best
        self.question.answers.update_all(best: false)
        self.update(best: true)
    end
  end
end
