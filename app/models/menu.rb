class Menu < ActiveRecord::Base
  has_many :menu_items
  validates :name, presence: true

  def self.findmenu(menu_id)
    menu = Menu.find(id: menu_id)
    if menu != nil
      return menu
    else
      return Menu.first
    end
  end
end
