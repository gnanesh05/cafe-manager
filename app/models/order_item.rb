class OrderItem < ApplicationRecord
  belongs_to :menu_item
  belongs_to :order
  validates :quantity, presence: true

  def self.current_order(order)
    where("order_id = ?", order.id)
  end

  def self.current_order_item(order, item)
    where("order_id = ? and menu_item_id = ?", order.id, item.id)
  end
end
