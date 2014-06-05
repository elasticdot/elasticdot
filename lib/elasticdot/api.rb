class ElasticDot::API
  require 'restclient'
  require 'json'

  attr_reader :email, :host

  def initialize(opts = {})
    @host  = opts[:host] || 'https://api.elasticdot.com'

    if opts[:email] and opts[:password]
      @email, @pass = opts[:email], opts[:password]
    else
      @email, @pass = ElasticDot::Command::Auth.credentials
    end
  end

  def login
    return unless (@email && @pass)

    @pass = RestClient.post(
      "#{@host}/auth",
      email: @email, password: @pass
    )
  rescue => e
    puts e.response
    exit 1
  end

  def method_missing(m, *args, &block)
    unless ['get', 'post', 'put', 'delete'].include? m.to_s
      raise NoMethodError, "undefined method: #{m}"
    end

    res = self.send('req', m, args)
    JSON.parse res rescue ""
  end

  private
  def req(method, *args)
    raise if args.empty?
    args = args.shift
    path = args.shift

    resource = RestClient::Resource.new(
      "#{@host}#{path}", user: @email, password: @pass
    )

    begin
      resource.send method, (args.first || {})
    rescue => e
      if e.respond_to? :response
        puts e.response
      else
        puts 'Something went wrong, we have been notified.'
      end

      exit 1
    end
  end
end
