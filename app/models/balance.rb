class Balance < ActiveRecord::Base
  belongs_to :brother

  enum kind: [:kitchen, :house, :social]

  validates :value, numericality: true, presence: true
  validates :brother, presence: true

  validates :brother_id, uniqueness: {scope: :kind}
end
