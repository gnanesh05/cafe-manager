class Order < ApplicationRecord
  has_many :order_items
  belongs_to :user

  def self.of_user(user)
    all.where("user_id = ? and status = ?", user.id, "received")
  end

  def self.all_user(user)
    all.where("user_id = ?", user.id)
  end

  def self.current_order(user)
    all.where("user_id = ? and status = ?", user.id, "not placed").last
  end

  def self.all_orders()
    all.where.not("status=?", "not placed")
  end

  def self.report_orders(date1)
    all.where("created_at < ?", date1)
  end

  def self.received_orders()
    all.where(status: "received", delivered_at: nil)
  end

  def self.delivered_orders()
    all.where(status: "delivered")
  end

  def self.user_delivered(user)
    all.where(user_id: user.id, status: "delivered")
  end

  def self.last_order(user)
    all.where("user_id = ?", user.id).last
  end

  def self.find_order(order)
    all.where("id =?", order.id)
  end
end
