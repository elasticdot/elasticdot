class ElasticDot::Command::Logs < ElasticDot::Command::Base
  def self.list(opts)
    app = opts[:app]

    validate_app! app

    api    = ElasticDot::API.new
    max_id = nil

    begin
      res = api.get "/apps/#{app}/logs?max_id=#{max_id}"
      max_id, events = res['max_id'], res['events']
      events.each {|e| puts e }
      sleep 2
    end while opts[:follow]
  end

  private
  def self.apps_info(app)
    api  = ElasticDot::API.new
    info = api.get "/domains/#{app}"

    app_tier = info['production'] ? 'production' : 'development'
    {app_tier: app_tier, scaling: info['scaling'], tier: info['dot_tier']['name'], dots: info['min_dots'] }
  end
end
