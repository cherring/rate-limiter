class RateLimit

  attr_accessor :ip_address, :maximum_requests, :time_period
  attr_reader :requests

  def initialize(ip_address, maximum_requests: 100, time_period: 60.minutes.ago)
    self.ip_address = ip_address
    self.maximum_requests = maximum_requests
    self.time_period = time_period
  end

  def requests
    @requests ||= Request.requests_for_ip_during_time_period(ip_address, time_period: time_period)
  end

  def request_permitted?
    requests.size < maximum_requests
  end

  def time_until_next_request_permitted
    interval = Time.zone.now - time_period # Gets the period we are limiting for in seconds
    next_request_at = (requests.last + interval)
    next_request_in = (next_request_at - Time.zone.now).to_i
    "Rate limit exceeded, please try again in #{next_request_in} seconds"
  end



end
