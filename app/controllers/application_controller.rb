class ApplicationController < ActionController::API
  require 'jwt_base'
  require 'net/http'

  @@jwt_base = JWTBase::JWTBase.new(ENV['SECRET_KEY_BASE'], 1.days, 2.weeks)

  def oauth_required
    begin
      authorization = request.authorization.split
    rescue NoMethodError
      return render status: 401
    end

    return render status: 401 unless authorization[0] == 'Bearer'

    url = URI.parse('https://www.googleapis.com/oauth2/v2/userinfo')
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    req = Net::HTTP::Get.new(url.request_uri)
    req.add_field('Authorization', authorization)

    @resp = JSON.parse(http.request(req).body)

    if @resp['error']
      return render status: @resp['error']['code'],
                    json: @resp['error']['message']
    end
  end

  def jwt_required
    begin
      authorization = request.authorization.split
    rescue NoMethodError
      return render status: 401
    end

    if authorization[0] == 'Bearer'
      token = authorization[1]
    else
      return render status: 401
    end

    @payload = @@jwt_base.get_jwt_payload(token)

    return render status: 401 unless @payload
    return render status: @payload['err'] if @payload['err']
    return render status: 403 unless @payload['type'] == 'access_token'
  end

  def refresh_token_required
    begin
      authorization = request.authorization.split
    rescue NoMethodError
      return render status: 401
    end

    if authorization[0] == 'Bearer'
      token = authorization[1]
    else
      return render status: 401
    end

    @payload = @@jwt_base.get_jwt_payload(token)

    return render status: 401 unless @payload
    return render status: @payload['err'] if @payload['err']
    return render status: 403 unless @payload['type'] == 'refresh_token'
  end

  def requires(*args, **kwargs)
    unless args.blank?
      args.each do |arg|
        params.require(arg.to_sym)
      end
    end

    unless kwargs.blank?
      kwargs.each do |key, value|
        raise TypeError unless value.class == Class

        params.require(key.to_sym)
        return render status: 400 unless params[key.to_sym].class == value
      end
    end

    @params = params
  end
end
