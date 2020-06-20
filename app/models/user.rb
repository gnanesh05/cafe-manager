class User < ApplicationRecord
  validates :name, presence: true
  validates :email, presence: true

  has_secure_password
  has_many :orders

  def self.customers
    all.where("role= ? and name != ?", "user", "Walk-in customer")
  end

  def self.clerk
    all.where("role = ?", "clerk")
  end

  def self.walk_in_customer
    where("name = ?", "walk-in customer")
  end
end
