class Voucher < ActiveRecord::Base
  include AASM

  belongs_to :brother, class_name: "Brother"

  has_many :line_items
  has_many :receipts

  validates :title, presence: true, length: {minimum: 5, maximum: 100}

  enum state: [
    :draft,
    :pending_officer_signatures,
    :pending_president_signature,
    :pending_treasurer_signature,
    :approved,
    :declined
  ]

  aasm column: :state, enum: true do
    state :draft, initial: true
    state :pending_officer_signatures
    state :pending_president_signature
    state :pending_treasurer_signature
    state :approved
    state :declined

    event :publish do
      transitions from: :draft, to: :pending_officer_signatures
    end

    event :promote do
      transitions from: :pending_officer_signatures, to: :pending_president_signature
      transitions from: :pending_president_signature, to: :pending_treasurer_signature
      transitions from: :pending_treasurer_signature, to: :approved
    end

    event :decline do
      transitions from: [:pending_officer_signatures, :pending_president_signature, :pending_treasurer_signature], to: :declined
    end
  end

  def total_amount
    line_items.select { |i| !i.new_record? }.to_a.sum(&:amount)
  end
end
