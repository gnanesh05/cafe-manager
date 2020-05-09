class Order < ApplicationRecord
  has_many :order_items
  belongs_to :user

  def self.of_user(user)
    all.where("user_id = ? and status = ?", user.id, "received")
  end

  def self.current_order(user)
    all.where("user_id = ? and status = ?", user.id, "not placed").last
  end

  def self.received_orders()
    all.where(status: "received", delivered_at: nil)
  end

  def self.delivered_orders()
    all.where(status: "delivered")
  end

  def self.delivered_orders(user)
    all.where(user_id: user.id, status: "delivered")
  end
end
