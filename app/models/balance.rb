class Balance < ActiveRecord::Base
  belongs_to :brother

  enum kind: [:kitchen, :house, :social, :house_debt]

  validates :value, numericality: true, presence: true
  validates :brother, presence: true

  validates :brother_id, uniqueness: {scope: :kind}
end
