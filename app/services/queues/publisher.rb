require 'bunny'

class Queues::Publisher
  class << self
    def publish(exchange, task)
      fan = channel.fanout("fether.#{exchange}")
      fan.publish(task)
    end

    def channel
      @channel ||= connection.create_channel
    end

    def connection
      @connection ||= Bunny.new.tap(&:start)
    end
  end
end