class LineItem < ActiveRecord::Base
  belongs_to :voucher

  validates :title, presence: true, length: {minimum: 3, maximum: 100}
  validates :amount, presence: true, numericality: true
end
