class Request

  # scope :for_ip_address, -> (requesting_ip) { where(ip_address: requesting_ip)}
  def self.for_ip_address(requesting_ip)
    requests = JSON.parse(redis.get(requesting_ip) || [].to_json).map { |requested_at| Time.zone.parse(requested_at) }
  end

  def self.add(requesting_ip, requested_at: Time.zone.now)
    requests = JSON.parse(redis.get(requesting_ip) || [].to_json)
    requests << requested_at
    requests = requests.sort.reverse
    redis.set(requesting_ip, requests.to_json)
  end

  def self.requests_for_ip_during_time_period(ip_address, time_period: 60.minutes.ago)
    for_ip_address(ip_address).select { |requested_at| requested_at > time_period }
  end

  def self.count
    redis.keys.count
  end

  private

  def self.redis_connection
    @redis_connection = Redis.new
  end

  def self.redis
    namespace = "requests_#{Rails.env}".to_sym
    @redis = Redis::Namespace.new(namespace, redis: redis_connection)
  end

end
