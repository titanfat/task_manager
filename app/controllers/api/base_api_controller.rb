class Api::BaseApiController < ApplicationController
  before_action :authenticate_user!
  respond_to :json
end
