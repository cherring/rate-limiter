require 'rails_helper'

describe RateLimiter do
  let(:ip_address) { '127.0.0.1' }

  it 'knows the ip address that the rate limit is for' do
    rate_limiter = RateLimit.new(ip_address)
    expect(rate_limiter.ip_address).to eq(ip_address)
  end

  context do
    let(:request_ip) { '127.0.0.1' }
    let(:other_ip) { '10.0.0.10' }
    let!(:previous_requests) { (1..10).each { |number| Request.add(request_ip, requested_at: number.minutes.ago)} }
    let!(:other_requests) { (1..10).each { |number| Request.add(other_ip, requested_at: number.minutes.ago)} }
    let(:rate_limiter) { RateLimit.new(ip_address) }

    it 'can get the requests for a time period' do
      expect(rate_limiter.requests.size).to eq(10)
    end

    it 'reports if a request is permitted' do
      expect(rate_limiter.request_permitted?).to eq(true)
    end

    it 'reports if a request is not permitted' do
      rate_limiter = RateLimit.new(ip_address, maximum_requests: 5, time_period: 10.minutes.ago)
      expect(rate_limiter.request_permitted?).to eq(false)
    end

    it 'reports how long until a request from a non permitted ip can be made' do
      rate_limiter = RateLimit.new(ip_address, maximum_requests: 5, time_period: 6.minutes.ago)
      expect(rate_limiter.time_until_next_request_permitted).to eq("Rate limit exceeded, please try again in #{59} seconds")
    end

  end

end
