class ElasticDot::Command::Apps < ElasticDot::Command::Base
  def self.create(args, opts)
    api  = ElasticDot::API.new
    info = api.post apps_url, domain: args[0]

    if info['error']
      puts info['error']
      exit 1
    end

    puts "Creating app #{info['app_name']}... done"
    puts "http://#{info['app_name']}.elasticdot.io/ | #{info['app_repo']}"

    create_git_remote 'elasticdot', info['app_repo']
  end

  def self.destroy(opts)
    app = opts[:app]

    validate_app! app

    puts "Destroying app #{app}..."

    api = ElasticDot::API.new
    api.delete apps_url(app)
  end

  def self.info(opts)
    app = opts[:app]

    validate_app! app

    h = apps_info app

    puts "=== #{app}"
    puts
    puts "Git URL:\t#{h['git_repo']}"
    puts "Owner Email:\t#{h['owner_email']}"
    puts "Region:\t\tEU"
#   puts "Slug Size:\t#{h['slug_size']}"
    puts "Web URL:\thttp://#{h['live_address']}"
  end

  def self.list
    api       = ElasticDot::API.new
    apps      = api.get('/stats')['profile']['apps']

    puts '=== My Apps'
    puts

    apps.each do |app|
      puts app['name']
    end
  end

  private
  def self.apps_url(path = nil)
    "/domains/#{path}"
  end

  def self.apps_info(app)
    api  = ElasticDot::API.new
    api.get apps_url(app)
  end
end
