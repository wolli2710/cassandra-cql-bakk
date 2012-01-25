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

  def self.get_followers uid
    @@db.execute("SELECT * FROM followers WHERE fid = ?", uid).fetch
  end

  def self.update_message uid, content
    time = Time.now.to_i

    user = User.get_user uid
	  new_json_obj = {"content" => content, "email" => user['email']}.to_json

    @@db.execute("UPDATE messages set #{time} = ? WHERE uid = ?", new_json_obj, uid.to_s)

    follower = @@db.execute("SELECT * FROM followers").fetch
    unless follower.nil?
      follower.to_hash.each do |key, value|
        unless key == "uid"
          json_obj = {"content" => content, "user_id" => uid}.to_json
          @@db.execute("UPDATE timelines set #{time} = ? WHERE uid = ?", json_obj , key)
        end
      end
    end
  end

end
