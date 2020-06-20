class OrderItem < ApplicationRecord
  belongs_to :menu_item
  belongs_to :order
  validates :quantity, presence: true

  def self.current_order_items(order)
    where("order_id = ?", order.id)
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
end
