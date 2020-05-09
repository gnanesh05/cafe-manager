class Menu < ActiveRecord::Base
  has_many :menu_items
  validates :item, presence: true
  validates :rate, presence: true

  def self.all_menus
  end
end
