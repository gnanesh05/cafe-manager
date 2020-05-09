class MenuItem < ActiveRecord::Base
  validates :name, presence: true
  validates :price, presence: true
  belongs_to :menu

  def self.dinner
    all.where("category_name = 'Dinner'")
  end

  def self.breakfast
    all.where("category_name = 'Breakfast'")
  end

  def self.lunch
    all.where("category_name = 'lunch'")
  end
end
