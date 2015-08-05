class Voucher < ActiveRecord::Base
  include AASM

  default_scope -> { order('created_at DESC') }

  belongs_to :brother, class_name: "Brother"

  has_many :line_items
  has_many :receipts

  has_many :signatures, as: :signable

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

    event :publish, after: :create_signatures do
      transitions from: :draft, to: :pending_officer_signatures
    end

    event :promote do
      transitions from: :pending_officer_signatures, to: :pending_president_signature, guard: :can_promote?
      transitions from: :pending_president_signature, to: :pending_treasurer_signature, guard: :can_promote?
      transitions from: :pending_treasurer_signature, to: :approved, guard: :can_promote?, after: :record_approval
    end

    event :decline do
      transitions from: [:pending_officer_signatures, :pending_president_signature, :pending_treasurer_signature], to: :declined
    end
  end

  def total_amount
    line_items.select { |i| !i.new_record? }.to_a.sum(&:amount)
  end

  # the signatures required in the current stage
  def current_signatures
    category_map = {
      pending_officer_signatures: :as_officer,
      pending_treasurer_signature: :as_treasurer,
      pending_president_signature: :as_president
    }

    return [] if category_map[state.to_sym].nil?

    signatures.where(category: Signature.categories[category_map[state.to_sym]])
  end

  def pending_signatures?
    pending_officer_signatures? || pending_president_signature? || pending_treasurer_signature?
  end

  # signature callback

  def signature_signed(sig)
    promote! while may_promote?
  end

  def signature_declined(sig)
    decline!
  end

  private

    def create_signatures
      # officer signatures
      positions = line_items.map(&:budget_type).uniq
      positions.each do |p|
        signatures.create!(
          brother_id: Brother.officer(p).id,
          category: :as_officer
        )
      end

      # president signature
      signatures.create!(
        brother_id: Brother.officer(:president).id,
        category: :as_president
      )

      # treasurer signature
      signatures.create!(
        brother_id: Brother.officer(:treasurer).id,
        category: :as_treasurer
      )

      promote! while may_promote?
    end

    def record_approval
      self.approved_at = Time.now
    end

    # all required signatures are signed
    def can_promote?
      current_signatures.all?(&:signed?)
    end
end
