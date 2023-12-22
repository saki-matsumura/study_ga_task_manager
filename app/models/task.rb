class Task < ApplicationRecord
  # clientとworking_processはnilでもOK
  belongs_to :client, optional: true
  belongs_to :user

  has_many :working_processes, dependent: :destroy  # タスクが削除されたら、付随する工程も削除する
  has_many :bookmarks, dependent: :destroy
  has_many :bookmark_users, through: :bookmarks, source: :user
  validates :title, presence: true
  validates :note, length: { maximum: 140 }

  # 画像
  mount_uploader :image, ImageUploader

  # ソート
  scope :default, -> { order(created_at: :desc) }

  # フィルター


  # シンプルカレンダー
  def start_time
    self.deadline_on #simple_calendarに表示させる日付のカラムを指定
  end
end
