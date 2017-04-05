class Request < ActiveRecord::Base

  validates :ip_address, :requested_at, presence: true

  scope :within_interval, -> (threshold_time) { where("requested_at > ?", threshold_time) }
  scope :for_ip_address, -> (requesting_ip) { where(ip_address: requesting_ip)}

  def self.requests_for_ip_during_time_period(ip_address, time_period: 60.minutes.ago)
    for_ip_address(ip_address).within_interval(time_period).order('requested_at desc')
  end

end
