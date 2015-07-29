class LineItem < ActiveRecord::Base
  include PositionConstants

  belongs_to :voucher

  enum budget_type: POSITIONS

  validates :title, presence: true, length: {minimum: 3, maximum: 100}
  validates :amount, presence: true, numericality: true
  validates :purchase_date, presence: true
  validates :budget_type, presence: true, inclusion: POSITIONS_WITH_BUDGET.map(&:to_s)

  def self.budget_type_options
    POSITIONS_WITH_BUDGET.map { |p| [POSITION_NAMES[self.budget_types[p]], self.budget_types[p]] }
  end

  def budget_type_name
    POSITION_NAMES[self.class.budget_types[self.budget_type]]
  end
end
