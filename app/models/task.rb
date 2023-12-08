class Task < ApplicationRecord
  belongs_to :client
  belongs_to :working_process
  belongs_to :user

  validates :title, presence: true
  validates :note, length: { maximum: 140 }
end
