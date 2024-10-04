class Event < ApplicationRecord
  scope :past_events, -> { where("date < ?", Time.now) }
  scope :upcoming_events, -> { where("date > ?", Time.now) }
  validates :name, presence: true
  validates :date, presence: true
  belongs_to :creator, class_name: "User", foreign_key: "user_id"
  has_many :user_events
  has_many :participants, through: :user_events, source: :user
end
