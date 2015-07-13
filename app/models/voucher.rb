class Voucher < ActiveRecord::Base
  belongs_to :brother, class_name: "Brother"

  has_many :line_items
  has_many :receipts

  validates :title, presence: true, length: {minimum: 5, maximum: 100}

  def total_amount
    line_items.select { |i| !i.new_record? }.to_a.sum(&:amount)
  end
end
