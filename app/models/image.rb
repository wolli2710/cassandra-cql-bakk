class Image
	require 'digest'

  def self.get_gravatar email
    hash = Digest::MD5.hexdigest(email.downcase)
    "http://www.gravatar.com/avatar/#{hash}"
  end
end
