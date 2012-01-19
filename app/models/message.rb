class Message < Cassandra

  def self.delete_messages
    @@db.execute("TRUNCATE messages")
  end

  def self.delete_message(mid)
    @@db.execute("DELETE FROM messages WHERE mid=?", mid)
  end

  def self.get_messages
    @@db.execute("SELECT * FROM messages")
  end

  def self.count_messages
    count = @@db.execute("SELECT counters FROM message_count")
    count.fetch do |c|
      return c[0]
    end
    # count = @@db.execute("SELECT count(*) FROM messages")
    # count.fetch do |c|
    #   return c[0]
    # end
  end

  def self.get_followers uid
    @@db.execute("SELECT * FROM followers WHERE fid = ?", uid).fetch
  end

  def self.update_message uid, content
    time = Time.now.to_i
    @@db.execute("UPDATE messages set #{time} = ? WHERE uid = ?", content.to_s, uid.to_s)
    follower = @@db.execute("SELECT * FROM followers WHERE uid = ?", uid).fetch
    unless follower.nil?
      follower.to_hash.each do |key, value|
        unless key == "uid"
          json_obj = {"content" => content, "user_id" => uid}.to_json
          @@db.execute("UPDATE timelines set #{time} = ? WHERE uid = ?", json_obj , value)
        end
      end
    end
  end

end
