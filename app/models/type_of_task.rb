class TypeOfTask < ApplicationRecord
  has_many :working_processes

  # 空欄不可、30文字以内、重複不可
  validates :name, presence: true, length: { maximum: 30 }
  validates :name, uniqueness: true
end
