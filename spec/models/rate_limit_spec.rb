require 'rails_helper'

describe RateLimit do

  it 'requires an ip address' do
    rate_limit_request = RateLimit.new
    rate_limit_request.requested_at = Time.zone.now
    expect(rate_limit_request).to_not be_valid
    rate_limit_request.ip_address = '127.0.0.1'
    expect(rate_limit_request.save).to eq(true)
  end

  it 'requires the time a request was made' do
    rate_limit_request = RateLimit.new
    rate_limit_request.ip_address = '127.0.0.1'
    expect(rate_limit_request).to_not be_valid
    rate_limit_request.requested_at = Time.zone.now
    expect(rate_limit_request.save).to eq(true)
  end

  context do
    let(:request_ip) { '127.0.0.1' }
    let(:other_ip) { '10.0.0.10' }
    let!(:previous_requests) { (1..10).each { |number| RateLimit.create(ip_address: request_ip, requested_at: number.minutes.ago)} }
    let!(:other_requests) { (1..10).each { |number| RateLimit.create(ip_address: other_ip, requested_at: number.minutes.ago)} }

    it 'can count up requests for over a time period' do
      expect(RateLimit.within_interval(60.minutes.ago).size).to eq(20)
    end

    it 'can count up requests for a requesting ip address' do
      expect(RateLimit.for_ip_address(request_ip).size).to eq(10)
      expect(RateLimit.for_ip_address(other_ip).size).to eq(10)
    end

    it 'can count requests for a requesting ip address over a time period' do
      expect(RateLimit.requests_for_ip_during_time_period(request_ip).size).to eq(10)
      expect(RateLimit.requests_for_ip_during_time_period(request_ip, time_period: 6.minutes.ago).size).to eq(5)
    end

    it 'reports if a request is permitted' do
      expect(RateLimit.request_permitted(request_ip)).to eq(true)
    end

    it 'reports if a request is not permitted' do
      expect(RateLimit.request_permitted(request_ip, maximum_requests: 1, time_period: 5.minutes.ago)).to eq(false)
    end

  end
end
