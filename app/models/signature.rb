class Signature < ActiveRecord::Base
  include AASM
  include PositionConstants
  include BudgetConstants

  before_validation :infer_position

  enum position: POSITIONS
  enum state: [:pending, :signed, :declined]
  enum category: [:as_officer, :as_president, :as_treasurer]

  belongs_to :signable, polymorphic: true
  belongs_to :brother

  validates :brother, presence: true
  validates :signable, presence: true
  validates :state, inclusion: {in: self.states.keys}
  validates :category, inclusion: {in: self.categories.keys}
  validates :position, inclusion: {in: self.positions.keys}

  aasm column: :state, enum: true do
    state :pending
    state :signed
    state :declined

    event :sign, after: :notify_signable do
      transitions from: :pending, to: :signed
    end

    event :decline, after: :notify_signable do
      transitions from: :pending, to: :declined
    end
  end

  def shortlog_signable_description
    "#{signable.brother.name}'s voucher titled [[#{signable.title}]]" if signable.is_a? Voucher
  end

  private

    def infer_position
      self.position = brother.position
    end

    def notify_signable
      signable.send(declined? ? :signature_declined : :signature_signed, self)
    end
end
