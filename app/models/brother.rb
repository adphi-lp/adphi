class Brother < ActiveRecord::Base
  include PositionConstants

  scope :current, -> { where(current: true) }

  belongs_to :pledge_class

  has_many :shortlogs, dependent: :destroy
  has_many :meetings, foreign_key: 'creator_id', dependent: :destroy
  has_many :attendences, dependent: :destroy
  has_many :balances, dependent: :destroy
  has_many :vouchers, dependent: :destroy
  has_many :signatures, dependent: :destroy
  has_many :late_dinners, dependent: :destroy

  validates :name, presence: true, length: {minimum: 1, maximum: 100}
  validates :kerberos, presence: true, length: {minimum: 1, maximum: 8}
  validates :year, presence: true, numericality: {only_integer: true, greater_than_or_equal_to: 1900, less_than_or_equal_to: 3000}
  validates :pledge_class, presence: true
  validates :current, :inclusion => {:in => [true, false]}

  serialize :positions
  serialize :late_dinner_days

  # FIXME: This only returns one Brother in case of multiple occupants of the same office
  def self.officer(position)
    officer = self.all.detect { |b| b.has_position?(position) }
    raise ActiveRecord::RecordNotFound, "Cannot find Brother with position " + position.to_s + "." if officer.nil?
    officer
  end

  def has_position?(pos)
    positions.include?(pos)
  end

  def has_voucher_dashboard?
    (Signature::POSITIONS_WITH_BUDGET + [:president, :treasurer]).detect { |p| has_position?(p) }.present?
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

  # Get the email for this brother
  def email
    return self.kerberos + "@mit.edu"
  end

  # Post notification
  def post_notification(title, content, link)
    # post email notification
    NotificationsMailer.notification_email(
      self.email,
      "[ADP Dashboard] #{title}",
      content,
      link
    ).deliver
  end
end
