class Receipt < ActiveRecord::Base
  has_attached_file :content

  validates_attachment_file_name :content, :matches => [/png\Z/, /jpe?g\Z/, /gif\Z/, /pdf\Z/, /txt\Z/]

  belongs_to :voucher
end
