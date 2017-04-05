class HomeController < ApplicationController
  before_action :check_rate_limit
  after_action :record_rate_limit_request

  def index
    render plain: "ok"
  end

  private

  def check_rate_limit
    rate_limiter = RateLimit.new(request.remote_ip)
    render plain: rate_limiter.time_until_next_request_permitted, status: 429 unless rate_limiter.request_permitted?
  end

  def record_rate_limit_request
    Request.create(ip_address: request.remote_ip, requested_at: Time.zone.now)
  end

end
