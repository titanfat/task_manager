# frozen_string_literal: true

class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User
  extend Devise::Models

  belongs_to :project
  has_and_belongs_to_many :sprints, join_table: :sprints_users, dependent: :destroy
  has_many :tasks, dependent: :destroy

  enum role: { admin: "admin", user: "user", executor: "executor", editor: "editor" }

  before_validation :set_default_project, on: :create
  validates :role , presence: true, inclusion: { in: roles }

  def full_name
    "#{first_name} #{last_name}".squish
  end

  private

  def set_default_project
    self.project ||= Project.find_by(name: "Default Project")
  end
end
