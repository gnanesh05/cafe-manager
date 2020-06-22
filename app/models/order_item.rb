class OrderItem < ApplicationRecord
  belongs_to :menu_item
  belongs_to :order
  validates :quantity, presence: true

  def self.current_order_items_cost(order)
    order_items = where("order_id = ?", order.id)
    sum = 0
    order_items.each do |item|
      sum = sum + (item.menu_item_price * item.quantity)
    end
    sum
  end

  def self.current_order_items(order)
    all.where("order_id = ?", order.id)
  end

  def self.gettotal(date1, date2)
    all.where("created_at >= ? AND created_at <= ? ", date1, date2)
      .select(:menu_item_name)
      .group(:menu_item_name)
      .pluck("menu_item_name,sum(menu_item_price),count(*)")
  end

  def self.reports(from_date, to_date)
    sum = all.gettotal(from_date, to_date)
    total_sum = sum.sum { |item, menu_item_price, quantity| menu_item_price }
    total_qty = sum.sum { |item, menu_item_price, quantity| quantity }
    report = {}
    sum.each { |menu_item_name, menu_item_price, quantity|
      report[menu_item_name] = { sum: menu_item_price,
                                 percent_price: ((menu_item_price * 100) / total_sum),
                                 quantity: quantity }
    }
    report
  end

  def self.get_items(order, menu_item)
    all.where("order_id = ? AND menu_item_id =?", order.id, menu_item.id).first
  end
end
