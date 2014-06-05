module ElasticDot::Command
  require 'elasticdot/api'
  require 'elasticdot/command/base'

  libs = Dir[File.join(File.dirname(__FILE__), "command", "*.rb")]
  libs.each { |file| require file }

  def self.run(args, opts)
    cmd  = args.shift

    unless cmd
      ElasticDot::Command::Help.root_help
      exit 0
    end

    klass, act = cmd.split ':', 2

    if klass.downcase == 'help'
      m = args.shift || 'root_help'
      m = m.split(':')[0]

      ElasticDot::Command::Help.send m
      exit 0
    end

    if ElasticDot::Command::Alias.respond_to? klass.downcase
      ElasticDot::Command::Alias.send klass.downcase, args, opts
      exit 0
    end

    act ||= 'list'

    ElasticDot::Command::Auth.authenticate!

    begin
      klass = "ElasticDot::Command::#{klass.capitalize}".constantize
    rescue
      unless ElasticDot::Command::Base.respond_to? cmd
        puts 'Invalid command: ' + cmd
        exit 1
      end

      return ElasticDot::Command::Base.send cmd
    end

    unless klass.respond_to? act
      puts 'Invalid action ' + act
      exit 1
    end

    method_args = klass.method(act).arity

    case method_args
    when 0
      klass.send act
    when 1
      klass.send act, opts
    when 2
      klass.send act, args, opts
    end
  end
end
