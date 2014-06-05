class ElasticDot::Command::Ps < ElasticDot::Command::Base
  def self.resize(settings, opts)
    app = opts[:app]

    validate_app! app

    params = apps_info app

    web = nil
    settings.each do |s|
      p, v = s.split('=',2)
      web = v and break if p == 'web'
    end

    unless web
      puts 'At the moment you can only resize web processes'
      exit 1
    end

    params[:tier] = web

    print "Resizing dynos and restarting specified processes... "

    api = ElasticDot::API.new
    api.put "/websites/#{app}/scaling", params

    puts 'done'
    puts "web dots now #{web}"
  end

  def self.scale(settings, opts)
    app = opts[:app]

    validate_app! app

    params = apps_info app

    web = nil
    settings.each do |s|
      p, v = s.split('=',2)
      web = v and break if p == 'web'
    end

    unless web
      puts 'Usage: elasticdot ps:scale web=N --app APP'
      exit 1
    end

    params[:dots] = web

    print "Scaling web processes... "

    api = ElasticDot::API.new
    api.put "/websites/#{app}/scaling", params

    params = apps_info app
    puts "done, now running #{params[:dots]}"
  end

  def self.list(opts)
    require 'time'

    app = opts[:app]
    validate_app! app

    api  = ElasticDot::API.new
    info = api.get("/domains/#{app}")

    tier = info['dot_tier']
    dots = info['dots']

    puts "=== web (#{tier['name']}): #{info['procfile']}"
    dots.each_with_index do |dot, i|
      now     = Time.now
      elapsed = now - Time.parse(dot['started_at'])
      since   = time_ago(now - elapsed)

      puts "web.#{i+1}: up #{since}"
    end
  end

  def self.restart(opts)
    app = opts[:app]
    validate_app! app

    print "Restarting dots... "

    api = ElasticDot::API.new
    api.post "/apps/#{app}/restart"

    puts "done"
  end

  def self.stop(opts)
    app = opts[:app]
    validate_app! app

    print "Stopping dots... "

    api = ElasticDot::API.new
    api.post "/apps/#{app}/stop"

    puts "done"
  end

  private
  def self.apps_info(app)
    api  = ElasticDot::API.new
    info = api.get "/domains/#{app}"

    app_tier = info['production'] ? 'production' : 'development'
    {app_tier: app_tier, scaling: info['scaling'], tier: info['dot_tier']['name'], dots: info['min_dots'] }
  end

  def self.time_ago(since)
    if since.is_a?(String)
      since = Time.parse(since)
    end

    elapsed = Time.now - since

    message = since.strftime("%Y/%m/%d %H:%M:%S")
    if elapsed <= 60
      message << " (~ #{elapsed.floor}s ago)"
    elsif elapsed <= (60 * 60)
      message << " (~ #{(elapsed / 60).floor}m ago)"
    elsif elapsed <= (60 * 60 * 25)
      message << " (~ #{(elapsed / 60 / 60).floor}h ago)"
    end
    message
  end
end
