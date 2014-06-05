class ElasticDot::Command::Keys < ElasticDot::Command::Base
  def self.add
    associate_or_generate_ssh_key
  end

  def self.remove(keys, opts)
    api   = ElasticDot::API.new
    rkeys = api.get('/stats')['profile']['keys']

    keys.each do |k|
      rk = rkeys.select {|rk| rk['content'] =~ /#{k}/ }.first
      api.delete "/account/keys/#{rk['id']}"
    end
  end

  def self.clear
    api = ElasticDot::API.new
    api.get('/stats')['profile']['keys'].each do |k|
      api.delete "/account/keys/#{k['id']}"
    end
  end

  def self.list
    api = ElasticDot::API.new

    puts "=== #{api.email} Keys"
    keys = api.get('/stats')['profile']['keys'].each do |k|
      puts k['content']
    end
  end

  private
  def self.associate_or_generate_ssh_key
    api         = ElasticDot::API.new
    public_keys = Dir.glob("#{Dir.home}/.ssh/*.pub").sort

    case public_keys.length
    when 0 then
      puts  "Could not find an existing public key."
      print "Would you like to generate one? [Yn] "

      if ask.strip.downcase == "y"
        puts "Generating new SSH public key."
        generate_ssh_key("id_rsa")
        associate_key("#{Dir.home}/.ssh/id_rsa.pub")
      end
    when 1 then
      puts "Found existing public key: #{public_keys.first}"
      associate_key(public_keys.first)
    else
      puts "Found the following SSH public keys:"
      public_keys.each_with_index do |key, index|
        puts "#{index+1}) #{File.basename(key)}"
      end

      print "Which would you like to use with your ElasticDot account? "
      choice = ask.to_i - 1
      chosen = public_keys[choice]
      if choice == -1 || chosen.nil?
        puts "Invalid choice"
        exit 1
      end

      associate_key(chosen)
    end
  end

  def self.generate_ssh_key(keyfile)
    ssh_dir = File.join(Dir.home, ".ssh")
    unless File.exists?(ssh_dir)
      FileUtils.mkdir_p ssh_dir
      File.chmod(0700, ssh_dir)
    end

    output = `ssh-keygen -t rsa -N "" -f \"#{Dir.home}/.ssh/#{keyfile}\" 2>&1`
    if ! $?.success?
      puts "Could not generate key: #{output}"
      exit 1
    end
  end

  def self.associate_key(key)
    puts "Uploading SSH public key #{key}"

    if File.exists?(key)
      api = ElasticDot::API.new
      api.post '/account/keys', ssh_key: File.read(key)
    else
      puts "Could not upload SSH public key: key file '" + key + "' does not exist"
      exit 1
    end
  end
end
