class Client < ApplicationRecord
  has_many :tasks, dependent: :destroy # 取引先が削除されたら、関連タスクも削除される

  validates :name, uniqueness: true
  validates :name, presence: true
end
