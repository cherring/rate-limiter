class HomeController < ApplicationController

  after_action :record_rate_limit_request

  def index
    render plain: "ok"
  end

  private

  def record_rate_limit_request
    Request.create(ip_address: request.remote_ip, requested_at: Time.zone.now)
  end

end
