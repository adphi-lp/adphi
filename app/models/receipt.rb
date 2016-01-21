class Receipt < ActiveRecord::Base
  has_attached_file :content

  validates_attachment_file_name :content, :matches => [/png\Z/i, /jpe?g\Z/i, /gif\Z/i, /pdf\Z/i, /txt\Z/i]

  belongs_to :voucher
end
