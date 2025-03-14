# frozen_string_literal: true
# == Schema Information
#
# Table name: sprints
#
#  id          :bigint           not null, primary key
#  end_date    :datetime         not null
#  settings    :jsonb            not null
#  start_date  :datetime         not null
#  tasks_count :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  project_id  :bigint           not null
#
# Indexes
#
#  index_sprints_on_project_id  (project_id)
#  index_sprints_on_settings    (settings) USING gin
#
# Foreign Keys
#
#  fk_rails_...  (project_id => projects.id)
#
class Sprint < ApplicationRecord
  has_and_belongs_to_many :users, join_table: :sprints_users, dependent: :nullify, foreign_key: :sprint_id
  has_many :tasks, inverse_of: :sprint
  belongs_to :project, inverse_of: :sprints, counter_cache: true

  validates :start_date, presence: true
  validates :end_date, presence: true
  validate :dates_valid

  after_commit :create_event_handler, on: :create

  scope :current, -> { where("start_date <= ? and end_date >= ?", Date.current, Date.current).limit(1).first }

  def admins
    users.where(role: 'admin')
  end

  def settings
    super || {}
  end

  def add_state_setting(prev, title, next_state)
    state_setting = { prev:, state: title, next: next_state }
    self.settings = { states: [].push(state_setting) } || self.settings
    self.save!
  end

  private

  def create_event_handler
    EventBus.instance.publish('sprint.created', sprint_id: id)
  end

  def dates_valid
    return if start_date.blank? || end_date.blank?

    errors.add(:start_date, "Sprint cannot be earlier") if start_date > end_date
  end
end
