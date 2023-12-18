class Client < ApplicationRecord
  has_many :tasks, dependent: :destroy # 取引先が削除されたら、関連タスクも削除される

  before_save :check_and_save

  validates :name, uniqueness: true
  validates :name, presence: true

  private

  def check_and_save
    return false unless name_blank?
  end

  def name_blank?
    !self.name.blank?
  end
end
