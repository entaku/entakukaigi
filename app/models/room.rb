class Room < Struct.new(:id)

  def members
    $redis.smembers redis_key
  end

  def add!(user_id)
    $redis.sadd redis_key, user_id
  end

  def destroy!(user_id)
    $redis.srem redis_key, user_id
    $redis.del(redis_key) if $redis.scard(redis_key) == 0
  end

  def destroy_all!
    $redis.del redis_key
  end

  def as_json(option = {})
    members
  end

  private

      def redis_key
        "rooms:#{@id}"
      end

end