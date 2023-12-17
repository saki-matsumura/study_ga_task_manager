class Task < ApplicationRecord
  # clientとworking_processはnilでもOK
  belongs_to :client, optional: true
  belongs_to :user

  # タスクが削除されたら、付随する工程も削除する
  has_many :working_processes, dependent: :destroy
  
  validates :title, presence: true
  validates :note, length: { maximum: 140 }

  # 画像
  mount_uploader :image, ImageUploader

  # ソート
  scope :default, -> { order(created_at: :desc) }
end
