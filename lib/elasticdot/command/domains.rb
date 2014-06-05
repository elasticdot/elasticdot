class ElasticDot::Command::Domains < ElasticDot::Command::Base
  def self.add(args, opts)
    domain = args.shift
    validate_domain! 'add', domain

    app    = opts[:app]
    validate_app! app

    puts "Adding #{domain} to #{app}..."

    api = ElasticDot::API.new
    api.post "/domains/#{app}/aliases", alias: domain
  end

  def self.remove(args, opts)
    domain = args.shift
    validate_domain! 'remove', 'domain'

    app    = opts[:app]
    validate_app! app

    puts "Removing #{domain} from #{app}..."

    api = ElasticDot::API.new
    api.delete "/domains/#{app}/aliases/#{domain}"
  end

  def self.clear(opts)
    app = opts[:app]
    validate_app! app

    api     = ElasticDot::API.new
    domains = api.get("/domains/#{app}")['aliases']

    puts "Removing all domain names from #{app}..."
    domains.each do |d|
      next if d['factory']
      api.delete "/domains/#{app}/aliases/#{d['name']}"
    end
  end

  def self.list(opts)
    app = opts[:app]
    validate_app! app

    api     = ElasticDot::API.new
    domains = api.get("/domains/#{app}")['aliases']

    puts "=== #{app} Domain Names"
    domains.each {|d| puts d['name'] }
  end

  private
  def self.validate_domain!(m, d)
    return true if d

    puts "Usage: elasticdot domains:#{m} DOMAIN"
    puts "Must specify DOMAIN to add."
    exit 1
  end
end
