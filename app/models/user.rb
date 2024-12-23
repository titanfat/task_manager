# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  allow_password_change  :boolean          default(FALSE)
#  confirmation_sent_at   :datetime
#  confirmation_token     :string
#  confirmed_at           :datetime
#  email                  :string
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  last_name              :string
#  name                   :string
#  nickname               :string
#  provider               :string           default("email"), not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :enum             default("user"), not null
#  tokens                 :json
#  uid                    :string           default(""), not null
#  unconfirmed_email      :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  project_id             :bigint           not null
#
# Indexes
#
#  index_users_on_confirmation_token        (confirmation_token) UNIQUE
#  index_users_on_email                     (email) UNIQUE
#  index_users_on_first_name_and_last_name  (first_name,last_name)
#  index_users_on_nickname                  (nickname) UNIQUE
#  index_users_on_project_id                (project_id)
#  index_users_on_reset_password_token      (reset_password_token) UNIQUE
#  index_users_on_uid_and_provider          (uid,provider) UNIQUE
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  include DeviseTokenAuth::Concerns::User
  extend Devise::Models

  belongs_to :project, inverse_of: :users
  has_and_belongs_to_many :sprints, join_table: :sprints_users, dependent: :nullify, foreign_key: :user_id
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
