class List < ApplicationRecord
  has_many :items
  has_and_belongs_to_many :affiliated_users, class_name: 'User', join_table: 'lists_users'

  belongs_to :user

  validates :title, presence: true
end
