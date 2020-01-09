class User < ActiveRecord::Base
  
  has_secure_password

  has_many :categories, through: :expenses
  has_many :expenses

  def categories_sort_by_name
    self.categories.all.sort_by {|category| category[:name]}
  end

  def total_amount
    self.expenses.collect {|expense| expense.amount}.sum
  end

  def expenses_sort_by_date
    self.expenses.sort_by {|expense| expense[:date]}.reverse
  end

end