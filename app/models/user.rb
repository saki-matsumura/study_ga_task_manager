class User < ApplicationRecord
  has_many :tasks, dependent: :destroy
  has_many :bookmarks, dependent: :destroy
  
  accepts_nested_attributes_for :tasks,
   allow_destroy: true

  validates :name, presence: true, length: { maximum: 30 }
  before_validation { email.downcase! }
  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i }
  validates :email, uniqueness: true
  has_secure_password
  validates :password, length: { minimum: 6 }, on: :create

  mount_uploader :icon, ImageUploader

  enum roll: {
    general: 0,  # 一般
    admin: 1,    # 管理者
  }

  def self.guest
    find_or_create_by!(email: 'guest@example.com') do |user|
      user.name = "ゲスト（一般）"
      user.password = SecureRandom.urlsafe_base64
    end
  end

  def self.guest_admin
    find_or_create_by!(email: 'guest_admin@example.com') do |user|
      user.name = "ゲスト（管理者）"
      user.roll = 1
      user.password = SecureRandom.urlsafe_base64
    end
  end

end
