class Menu < ActiveRecord::Base
  has_many :menu_items
  validates :name, presence: true

  def self.find_next_menu(menu)
    all.where("name!= ?", menu.name)
  end
end
