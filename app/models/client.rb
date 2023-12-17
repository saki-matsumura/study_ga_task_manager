class Client < ApplicationRecord
  has_many :tasks

  validates :name, uniqueness: true
  validates :name, presence: true
end
