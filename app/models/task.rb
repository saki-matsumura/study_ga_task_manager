class Task < ApplicationRecord
  # clientとworking_processはnilでもOK
  belongs_to :client, optional: true
  accepts_nested_attributes_for :client,
    reject_if: :all_blank

  belongs_to :user

  # タスクが削除されたら、付随する工程も削除する
  has_many :working_processes
  accepts_nested_attributes_for :working_processes,
    allow_destroy: true,
    reject_if: :all_blank
  
  validates :title, presence: true
  validates :note, length: { maximum: 140 }

  # 画像
  mount_uploader :image, ImageUploader
end
