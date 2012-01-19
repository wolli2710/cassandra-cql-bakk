class Cassandra

  require 'cassandra-cql'

  @@db = CassandraCQL::Database.new('127.0.0.1:9160')
  @@db.execute("USE cql_test")

  def self.connect
    @@db.execute("CREATE KEYSPACE cql_test WITH strategy_class='org.apache.cassandra.locator.SimpleStrategy' AND strategy_options:replication_factor=1")
    @@db.execute("USE cql_test")

    @@db.execute("CREATE COLUMNFAMILY users (uid varchar PRIMARY KEY, first_name varchar, last_name varchar, email varchar)" )
    @@db.execute("CREATE INDEX users_id_idx ON users (email)")

    @@db.execute("CREATE COLUMNFAMILY messages (uid varchar PRIMARY KEY, tstamp varchar)" )

    @@db.execute("CREATE COLUMNFAMILY timelines (uid varchar PRIMARY KEY, fidtime varchar, content varchar)" )

    @@db.execute("CREATE COLUMNFAMILY user_count(cid varchar PRIMARY KEY, counters counter) WITH default_validation = CounterColumnType")
    @@db.execute("update user_count set counters = counters + 0 where cid = counters ")

    @@db.execute("CREATE COLUMNFAMILY message_count(cid varchar PRIMARY KEY, counters counter) WITH default_validation = CounterColumnType")
    @@db.execute("update message_count set counters = counters + 0 where cid = counters ")

    @@db.execute("CREATE COLUMNFAMILY followers(fid varchar PRIMARY KEY, uid varchar)" )
    @@db.execute("CREATE INDEX users_follower_id_idx ON followers (uid)")

    @@db.execute("CREATE COLUMNFAMILY following(uid varchar PRIMARY KEY, fid varchar)" )
  end

  def self.drop_keyspace
    @@db.execute("DROP KEYSPACE cql_test")
  end

  def self.delete_column_families
     @@db.execute("DROP COLUMNFAMILY users")
     @@db.execute("DROP COLUMNFAMILY messages")
     @@db.execute("DROP COLUMNFAMILY timelines")
     @@db.execute("DROP COLUMNFAMILY user_count")
     @@db.execute("DROP COLUMNFAMILY message_count")
     @@db.execute("DROP COLUMNFAMILY followers")
     @@db.execute("DROP COLUMNFAMILY following")
  end

end
