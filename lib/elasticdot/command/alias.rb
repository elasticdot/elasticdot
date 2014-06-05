class ElasticDot::Command::Alias < ElasticDot::Command::Base
  def self.login(*opts)
    ElasticDot::Command::Auth.login
  end

  def self.logout(*opts)
    ElasticDot::Command::Auth.logout
  end

  def self.signup(*opts)
    puts 'Please go to: https://s.elasticdot.com/signup'
  end

  def self.version(*opts)
    puts 'ElasticDot CLI 1.0.0'
  end

  def self.ls(*opts)
    ElasticDot::Command::Apps.list
  end

  def self.create(args, opts)
    ElasticDot::Command::Apps.create args, opts
  end

  def self.info(args, opts)
    ElasticDot::Command::Apps.info opts
  end
end
