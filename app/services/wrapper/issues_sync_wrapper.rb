class Wrapper::IssuesSyncWrapper < Wrapper::BaseServiceWrapper
  include TaskParser

  ENDPOINT = "https://tit22an.atlassian.net".freeze

  def initialize(current_sprint = nil, api_key = nil)
    @current_sprint = current_sprint
    super("issue sync", ENDPOINT)
  end

  def call
    tasks ||= begin
      tasks_parser(tasks_fetcher)
    rescue Faraday::ConnectionFailed => e
      render json: e.message
    end

    byebug
  end

  private

  # def sprint_fetcher
  #
  # end

  def tasks_fetcher
    @tasks_fetcher ||= begin
      response = connection.get do |req|
        # TODO find current sprint in jira board and catch data
        req.url "/rest/agile/1.0/sprint/2/issue"
        req.headers['Content-Type'] = 'application/json'
      end

      response = response&.body
      response['issues']
    end
  end
end