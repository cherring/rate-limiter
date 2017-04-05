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

    it 'orders the requests by requested at, newest to oldest' do
      requests = Request.requests_for_ip_during_time_period(request_ip)
      requests.each_with_index do |request, counter|
        if counter < (requests.size - 1) # Don't try to compare the last one against something outside the array
          expect(request.requested_at > requests[counter + 1].requested_at).to eq(true)
        end
      end
    end

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

  end
end
