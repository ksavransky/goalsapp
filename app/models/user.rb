class User < ActiveRecord::Base
  validates :username, :session_token, :password_digest, presence: true
  validates :password, length: {minimum: 6, allow_nil: true}

  attr_reader :password

  after_initialize :ensure_token

  def password=(password)
    @password = password
    self.password_digest = BCrypt::Password.create(password)
  end

  def generate_token
    SecureRandom.urlsafe_base64(32)
  end

  def valid_password?(password)
    BCrypt::Password.new(self.password_digest).is_password?(password)
  end

  def self.find_by_credentials(username, password)
    user = User.find_by_username(username)
    return nil unless user
    user.valid_password?(password) ? user : nil
  end

  def reset_token
    self.session_token = generate_token
    self.save
    self.session_token
  end

  def ensure_token
    self.session_token ||= generate_token
  end
end
