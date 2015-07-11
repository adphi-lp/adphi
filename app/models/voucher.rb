class Voucher < ActiveRecord::Base
  belongs_to :brother, class_name: "Brother"

  validates :title, length: {minimum: 5, maximum: 100}
end
