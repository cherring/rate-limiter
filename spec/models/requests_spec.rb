require 'rails_helper'

describe Request do

  it 'requires an ip address' do
    request = Request.new
    request.requested_at = Time.zone.now
    expect(request).to_not be_valid
    request.ip_address = '127.0.0.1'
    expect(request.save).to eq(true)
  end

  it 'requires the time a request was made' do
    request = Request.new
    request.ip_address = '127.0.0.1'
    expect(request).to_not be_valid
    request.requested_at = Time.zone.now
    expect(request.save).to eq(true)
  end

  context do
    let(:request_ip) { '127.0.0.1' }
    let(:other_ip) { '10.0.0.10' }
    let!(:previous_requests) { (1..10).each { |number| Request.create(ip_address: request_ip, requested_at: number.minutes.ago)} }
    let!(:other_requests) { (1..10).each { |number| Request.create(ip_address: other_ip, requested_at: number.minutes.ago)} }

    it 'can count up requests for over a time period' do
      expect(Request.within_interval(60.minutes.ago).size).to eq(20)
    end

    it 'can count up requests for a requesting ip address' do
      expect(Request.for_ip_address(request_ip).size).to eq(10)
      expect(Request.for_ip_address(other_ip).size).to eq(10)
    end

    it 'can count requests for a requesting ip address over a time period' do
      expect(Request.requests_for_ip_during_time_period(request_ip).size).to eq(10)
      expect(Request.requests_for_ip_during_time_period(request_ip, time_period: 6.minutes.ago).size).to eq(5)
    end

    it 'reports if a request is permitted' do
      expect(Request.request_permitted(request_ip)).to eq(true)
    end

    it 'reports if a request is not permitted' do
      expect(Request.request_permitted(request_ip, maximum_requests: 1, time_period: 5.minutes.ago)).to eq(false)
    end

  end
end
