class TypeOfTask < ApplicationRecord
  has_many :working_processes, dependent: :destroy # 大元の工程が削除されたら、タスクに登録されている各工程も削除される

  before_save :check_and_save

  # 空欄不可、30文字以内、重複不可
  validates :name, presence: true, length: { maximum: 30 }
  validates :name, uniqueness: true

  private

  def check_and_save
    return false unless name_blank?
  end

  def name_blank?
    !self.name.blank?
  end
end
