class Identity
  include DataMapper::Resource

  attr_accessor :password_confirmation

  property :id,               Serial
  property :email,            String
  property :crypted_password, String, :length => 60

  property :role,             String

  property :name, String
  has 1, :company

  validates_presence_of      :email,    :role
  validates_format_of        :email,    :with => :email_address
  validates_uniqueness_of    :email
  validates_format_of        :role,     :with => /[A-Za-z]/

  validates_presence_of      :crypted_password

  property :deleted_at,      ParanoidDateTime
  timestamps :at

  def password= password
    self.crypted_password = BCrypt::Password.create password
  end

  def self.authenticate(email, password)
    instance = first(:email => email)
    return false unless instance
    BCrypt::Password.new(instance.crypted_password) == password ? instance : nil
  end
end
