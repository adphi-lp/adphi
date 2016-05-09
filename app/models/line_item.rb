class LineItem < ActiveRecord::Base
  include PositionConstants
  include BudgetConstants

  validate :purchase_date_cannot_be_in_the_future

  belongs_to :voucher

  validates :title, presence: true, length: {minimum: 3, maximum: 100}
  validates :amount, presence: true, numericality: {greater_than: 0}
  validates :purchase_date, presence: true
  validates :budget_type, presence: true, inclusion: BUDGET_NAMES.keys

  def self.budget_type_options
    BUDGET_NAMES.map { |k, v| [v, k] }
  end

  def budget_type_name
    BUDGET_NAMES[self.budget_type]
  end

  def budget_officer
    BUDGET_OFFICERS[self.budget_type]
  end

  def restricted_budget_type_options
    (BUDGET_NAMES.map { |k, v| [v, k] if BUDGET_OFFICERS[k] == self.budget_officer }).compact
  end

  private

    def purchase_date_cannot_be_in_the_future
      errors.add(:purchase_date, "can't be in the future") if
        !purchase_date.blank? and purchase_date > Time.zone.today
    end
end
