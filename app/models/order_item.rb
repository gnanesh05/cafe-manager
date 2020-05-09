class OrderItem < ApplicationRecord
  belongs_to :menu_item
  belongs_to :order
  validates :quantity, presence: true

  def self.current_order(order)
    where("order_id = ?", order.id)
  end
end
