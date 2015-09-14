class LineItem < ActiveRecord::Base
  include PositionConstants
  include BudgetConstants

  belongs_to :voucher

  validates :title, presence: true, length: {minimum: 3, maximum: 100}
  validates :amount, presence: true, numericality: true
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
end
