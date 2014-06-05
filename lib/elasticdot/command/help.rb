class ElasticDot::Command::Help < ElasticDot::Command::Base
  def self.root_help
    puts <<-HELP
Usage: elasticdot COMMAND [--app APP] [command-specific-options]

Primary help topics, type "ElasticDot help TOPIC" for more details:

  apps      #  manage apps (create, destroy)
  keys      #  manage authentication keys
  config    #  manage app config vars
  domains   #  manage custom domains
  addons    #  manage addon resources

Additional topics:

  help         #  list commands and display help
  version      #  display version
    HELP
  end

  def self.apps
    puts <<-HELP
Apps commands:

  apps:create [NAME]      # create a new app
  apps:destroy --app APP  # permanently destroy an app
  apps:info    --app APP  # show detailed app information
  apps:list               # show app list
    HELP
  end

  def self.addons
    puts <<-HELP
Addons commands:

  addons:add ADDON                   #  install an addon
  addons:list                        #  list all available addons
  addons:remove ADDON1 [ADDON2 ...]  #  uninstall one or more addons
  addons:upgrade ADDON               #  upgrade an existing addon
    HELP
  end

  def self.domains
    puts <<-HELP
Domains commands:

  domains:add DOMAIN     #  add a custom domain to an app
  domains:clear          #  remove all custom domains from an app
  domains:remove DOMAIN  #  remove a custom domain from an app
    HELP
  end

  def self.keys
    puts <<-HELP
Keys commands:

  keys:add [KEY]     #  add a key for the current user
  keys:clear         #  remove all authentication keys from the current user
  keys:remove KEY    #  remove a key from the current user
    HELP
  end

  def self.config
    puts <<-HELP
Config commands:

  config:get KEY                            #  display a config value for an app
  config:set KEY1=VALUE1 [KEY2=VALUE2 ...]  #  set one or more config vars
  config:unset KEY1 [KEY2 ...]              #  unset one or more config vars
    HELP
  end

  def self.ps
    puts <<-HELP
PS commands:

  ps:resize   web=TIER   #  resize dot to the given tier
  ps:scale    web=N      #  scale dots by the given amount
  ps:stop                #  stop all dots
  ps:restart             #  restart all dots
    HELP
  end

  def self.method_missing(m, *args, &block)
    unless self.respond_to? m
      puts "Invalid command: #{m}"
      exit 1
    end
  end
end
