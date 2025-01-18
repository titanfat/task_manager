# frozen_string_literal: true
require 'faraday'

class Wrapper::BaseServiceWrapper

  def initialize(service_name, url)
    @service_name = service_name
    @url = url.to_s
    @api_key ||= ENV['JIRA_API_KEY'].to_s
    @api_user ||= ENV['JIRA_USER'].to_s
  end

  def status; end

  private

  class HTTPError < StandardError
  end
  class ServerError < HTTPError; end
  class ClientError < HTTPError; end


  def connection
    @connection ||= Faraday.new(@url, request: { timeout: 7.second  }) do |config|
      config.headers['Authorization'] = "Basic #{Base64.strict_encode64("#{@api_user}:#{@api_key}")}"
      config.response :json
    end
  end
end