class Follower < Cassandra

  def self.follow_user uid, fid
    time = Time.now.to_i

    @@db.execute("Update following set fid = ? where uid = ? ", fid.to_s, uid.to_s)
    @@db.execute("Update followers set uid = ? where fid = ? ", fid.to_s, uid.to_s)

    messages = User.get_messages fid
    i=0
    messages.to_hash.each do |key, value|
      unless key == "uid"
        i = i + 1
        a = {"content" => value.to_s, "user_id" => fid.to_s}.to_json
        @@db.execute("Update timelines set #{time + i} = ? where uid = ? ", a, uid)
      end
    end
  end

  def self.get_followings uid
    @@db.execute("SELECT * FROM following WHERE uid = #{uid}")
  end

end
