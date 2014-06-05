class ElasticDot::Command::Base
  protected
  def self.echo_off
    with_tty do
      system "stty -echo"
    end
  end

  def self.echo_on
    with_tty do
      system "stty echo"
    end
  end

  def self.with_tty(&block)
    return unless $stdin.isatty
    yield
  end

  def self.ask
    $stdin.gets.to_s.strip
  end

  def self.validate_app!(app)
    return true if app

    puts 'No app specified.'
    puts 'Specify which app to use with --app APP.'
    exit 1
  end

  def self.has_git?
    %x{ git --version }
    $?.success?
  end

  def self.git(args)
    return "" unless has_git?
    flattened_args = [args].flatten.compact.join(" ")
    %x{ git #{flattened_args} 2>&1 }.strip
  end

  def self.create_git_remote(remote, url)
    return if git('remote').split("\n").include?(remote)
    return unless File.exists?(".git")

    git "remote add #{remote} #{url}"

    puts "Git remote #{remote} added"
  end
end
