class OrderItem < ApplicationRecord
  belongs_to :menu_item
  belongs_to :order
  validates :quantity, presence: true

  def self.current_order_item(order, item)
    order_item = where("order_id = ? and menu_item_id = ?", order.id, item.id)
    if order_item
      return true
    else
      return false
    end
  end
end
