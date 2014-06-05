class ElasticDot::Command::Addons < ElasticDot::Command::Base
  def self.add(addon, opts)
    app = opts[:app]
    validate_app! app

    addon, tier = addon[0].split ':', 2

    puts "Configuring addon #{addon} for app #{app}..."

    api = ElasticDot::API.new
    api.post "/apps/#{app}/addons/#{addon}", tier: tier
  end

  def self.remove(addons, opts)
    app = opts[:app]
    validate_app! app

    api = ElasticDot::API.new

    addons.each do |addon|
      addon = addon.split(':')[0]

      puts "Removing addon #{addon} from app #{app}..."
      api.delete "/apps/#{app}/addons/#{addon}"
    end
  end

  def self.list
    api    = ElasticDot::API.new
    addons = api.get '/addons'

    puts '=== available'
    addons.each { |a, i| puts a['name'] }
  end
end
