class User < Cassandra

  require 'json'

  def self.get_messages uid
    @@db.execute("SELECT * FROM messages WHERE uid=?", uid).fetch
  end

  def self.get_timeline uid
    @@db.execute("SELECT * FROM timelines WHERE uid=?", uid)
  end

  def self.delete_users
    @@db.execute("TRUNCATE users")
    @@db.execute("update user_count set counters = counters - #{User.count_users} where cid = counters")
  end

  def self.delete_user(uid)
    @@db.execute("DELETE FROM users WHERE uid=?", uid)
  end

  def self.get_users
    @@db.execute("SELECT * FROM users")
  end

  def self.get_user uid
    @@db.execute("SELECT * FROM users WHERE uid = ?", uid).fetch
  end

  def self.count_users
    count = @@db.execute("SELECT counters FROM user_count")
    count.fetch do |c|
      return c[0]
    end
  end

  def self.update_counter(val)
    @@db.execute("update user_count set counters = counters + #{val} where cid = counters")
  end

  def self.update_user first_name, last_name, email
    uid = User.count_users + 1
    @@db.execute("INSERT INTO users (uid, first_name, last_name, email) VALUES (?,?,?,?)", uid, first_name, last_name, email)
    self.update_counter(1)
  end

  def self.follow_user uid, fid
    time = Time.now.to_i

    @@db.execute("Update followers set #{uid.to_s} = ? where fid = ? ", "", fid.to_s)

    messages = User.get_messages fid
    i=0
    messages.to_hash.each do |key, value|
      unless key == "uid"
        i = i + 1
        a = {"content" => JSON.parse(value)['content'], "user_id" => fid.to_s}.to_json
        @@db.execute("Update timelines set #{time + i} = ? where uid = ? ", a, uid)
      end
    end
  end

end
