# frozen_string_literal: true
class Wrapper::IssuesSyncWrapper < Wrapper::BaseServiceWrapper
  include TaskParser

  attr_reader :current_sprint, :external_sprint

  ENDPOINT = "https://tit22an.atlassian.net".freeze

  def initialize(current_sprint = Sprint.last)
    super("issue sync", ENDPOINT)
    @current_sprint = current_sprint
    @external_sprint ||= sprint || 2
  end

  def call
    tasks ||= begin
      tasks_parser(tasks_fetcher)
    rescue Faraday::ConnectionFailed => e
      render json: e.message
      Rails.logger.error("Integration error: #{e.message}")
    end
  end

  private

  def sprint
    @sprint ||= begin
      response = connection.get do |req|
        req.url "/rest/agile/1.0/board/1/sprint"
        req.headers['Content-Type'] = 'application/json'
      end

      raise "Fail fetch sprint #{response.status}" unless response.success?

      response = response&.body
      response['values'].select do |s|
        date_range = current_sprint&.start_date.to_date...current_sprint&.end_date.to_date
        date_range.include? Date.parse(s['startDate']) || Date.parse(s['endDate'])
      end.last || response['values'].last
    end
  rescue Faraday::ConnectionFailed => e
    Rails.logger.error("Integration error: #{e.message}")
    nil
  end

  def tasks_fetcher
    @tasks_fetcher ||= begin
      response = connection.get do |req|
        # TODO find current sprint in jira board and catch data
        req.url "/rest/agile/1.0/sprint/#{@external_sprint['id']}/issue"
        req.headers['Content-Type'] = 'application/json'
      end

    raise "Fail fetch tasks #{response.status}" unless response.success?

      response = response&.body
      response['issues']
   end
  end
end