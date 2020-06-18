class MenuItem < ActiveRecord::Base
  validates :name, presence: true
  validates :price, presence: true
  validates :description, presence: true
  validates :category_name, presence: true
  validates :menu_id, presence: true
  belongs_to :menu

  def self.dinner(menu)
    all.where("category_name = ? and menu_id = ?", "Dinner", menu.id)
  end

  def self.breakfast(menu)
    all.where("category_name = ? and menu_id = ?", "Breakfast", menu.id)
  end

  def self.lunch(menu)
    all.where("category_name = ? and menu_id = ?", "lunch", menu.id)
  end

  def self.description(description, menu)
    all.where("description = ? and menu_id = ?", description, menu.id)
  end

  def self.of_menu(menu)
    all.where("menu_id = ?", menu.id)
  end
end
