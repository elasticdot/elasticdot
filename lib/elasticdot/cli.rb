module ElasticDot
  libs = Dir[File.join(File.dirname(__FILE__), "initializers", "*.rb")]
  libs.each { |file| require file }

  require 'elasticdot/command'

  class CLI
    require 'optparse'

    def self.parse(args)
      options = {}

      opt_parser = OptionParser.new do |opts|
        opts.banner = "Usage: example.rb [options]"

        opts.on("-a", "--app APP_NAME", "Specify the app involved") do |v|
          options[:app] = v
        end

        opts.on("-f", "--follow", "Continue running and print new events (off)") do |v|
          options[:follow] = v
        end

        opts.on("-h", "--help", "Show this help") do |v|
          options[:help] = true
        end
      end

      opt_parser.parse! args

      [ARGV, options]
    end

    def self.run(args)
      cmd, opts = parse ARGV
      ElasticDot::Command.run cmd, opts
    end
  end
end
