class ElasticDot::Command::Config < ElasticDot::Command::Base
  def self.set(vars, opts)
    unless vars.size > 0 and vars.all? { |a| a.include?('=') }
      puts "Usage: elasticdot config:set KEY1=VALUE1 [KEY2=VALUE2 ...]\nMust specify KEY and VALUE to set."
      exit 1
    end

    vars = parse_vars! vars

    app = opts[:app]
    validate_app! app

    puts "Setting ENV vars and restarting #{app}..."

    api = ElasticDot::API.new
    api.post "/apps/#{app}/vars", vars: vars

    vars.each { |k, v| puts "#{k}:\t#{v}" }
  end

  def self.unset(vars, opts)
    if vars.empty?
      puts "Usage: elasticdot config:unset KEY1 [KEY2 ...]\nMust specify KEY to unset."
      exit 1
    end

    app = opts[:app]
    validate_app! app

    puts "Unsetting ENV vars and restarting #{app}..."

    api = ElasticDot::API.new
    api.post "/apps/#{app}/vars/unset", vars: vars
  end

  def self.get(args, opts)
    var = args.shift
    app = opts[:app]
    validate_app! app

    api  = ElasticDot::API.new
    vars = api.get("/domains/#{app}")['vars']

    value = vars.select {|v| v['key_name'] == var }.first['value'] rescue nil

    puts value if value
  end

  def self.list(opts)
    app = opts[:app]
    validate_app! app

    puts "=== #{app} Config Vars"

    api  = ElasticDot::API.new
    vars = api.get("/domains/#{app}")['vars']

    vars.each {|v| puts "#{v['key_name']}:\t#{v['value']}" }
  end

  private
  def self.parse_vars!(vars)
    parsed_vars = {}

    vars.each do |var|
      k, v = var.split '=', 2
      parsed_vars[k] = v || ''
    end

    parsed_vars
  end
end
