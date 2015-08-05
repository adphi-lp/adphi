class Brother < ActiveRecord::Base
  include PositionConstants

  scope :current, -> { where(current: true) }

  # the order of this must NOT be changed! new entries MUST go at the end
  enum position: POSITIONS

  belongs_to :pledge_class

  has_many :shortlogs, dependent: :destroy
  has_many :meetings, foreign_key: 'creator_id', dependent: :destroy
  has_many :attendences, dependent: :destroy
  has_many :balances, dependent: :destroy
  has_many :vouchers, dependent: :destroy
  has_many :signatures, dependent: :destroy

  validates :name, presence: true, length: {minimum: 1, maximum: 100}
  validates :kerberos, presence: true, length: {minimum: 1, maximum: 8}
  validates :year, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 1900, less_than_or_equal_to: 3000}
  validates :pledge_class, presence: true
  validates :current, :inclusion => {:in => [true, false]}

  def self.officer(position)
    find_by!(position: self.positions[position])
  end

  def has_voucher_dashboard?
    president? || treasurer? ||
    (position.present? && (Signature::POSITIONS_WITH_BUDGET.include? position.to_sym))
  end

  # Fetch balances

  def balance(kind)
    begin
      balances.find_by!(kind: Balance.kinds[kind])
    rescue ActiveRecord::RecordNotFound
      create_missing_balances
      balances.find_by!(kind: Balance.kinds[kind])
    end
  end

  after_initialize do
    if new_record?
      self.current = true
    end
  end

  # Create missing balances

  after_save :create_missing_balances
  def create_missing_balances
    Balance.kinds.each do |k, v|
      Balance.create_with(value: 0).find_or_create_by(brother_id: id, kind: v)
    end
  end
end
