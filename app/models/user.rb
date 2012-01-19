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
    # count = @@db.execute("SELECT count(*) FROM users limit 20000")
    # count.fetch do |c|
    #   return c[0]
    # end
  end

  def self.update_counter(val)
    @@db.execute("update user_count set counters = counters + #{val} where cid = counters")
  end

  def self.new_user
    uid = User.count_users + 1
    @@db.execute("INSERT INTO users (uid, first_name, last_name, email) VALUES (?,?,?,?)", uid, "", "", "")
    self.update_counter(1)
    uid
  end

  def self.update_user uid, first_name, last_name, email
    @@db.execute("update users set first_name = ?, last_name = ?, email = ? where uid = ?", first_name, last_name, email, uid)
  end

  def self.mail_check uid
    user = User.get_user uid
    return user['email'] == "" ? false : true ;
  end

  def self.create_users
    (0..19000).each do |f|
      @@db.execute("INSERT INTO users (uid, first_name, last_name, email) VALUES (?,?,?,?)", f.to_s, "first_name", "last_name", "email")
      User.update_counter(1)
    end
  end

end
