class ElasticDot::Command::Auth < ElasticDot::Command::Base
  require 'netrc'

  def self.login
    puts "Enter your ElasticDot credentials."

    print "email: "
    email = ask

    print "password: "

    echo_off
    pass = ask_for_password
    echo_on

    api = ElasticDot::API.new(email: email, password: pass)
    key = api.login

    netrc.delete 'j.elasticops.com'

    netrc['j.elasticops.com'] = email, key
    netrc.save

    true
  end

  def self.logout
    netrc.delete 'j.elasticops.com'
    netrc.save

    true
  end

  def self.authenticate!
    return true if authenticated?
    login
  end

  def self.credentials
    netrc['j.elasticops.com']
  end

  private
  def self.netrc
    @netrc ||= Netrc.read netrc_path
  end

  def self.netrc_path
    default   = Netrc.default_path
    encrypted = default + ".gpg"

    File.exists?(encrypted) ? encrypted : default
  end

  def self.ask_for_password
    echo_off
    password = ask
    puts
    echo_on

    password
  end

  def self.authenticated?
    netrc['j.elasticops.com'] ? true : false
  end
end
