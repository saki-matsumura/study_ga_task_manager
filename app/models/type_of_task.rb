class TypeOfTask < ApplicationRecord
  has_many :working_processes, dependent: :destroy # 大元の工程が削除されたら、タスクに登録されている各工程も削除される

  # 空欄不可、30文字以内、重複不可
  validates :name, presence: true, length: { maximum: 30 }
  validates :name, uniqueness: true
end
