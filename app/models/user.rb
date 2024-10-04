class User < ApplicationRecord
  validates :name, presence: true
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # has_many :events
  has_many :created_events, class_name: "Event", foreign_key: "user_id", dependent: :destroy
  has_many :user_events
  has_many :participated_events, through: :user_events, source: :event
end
