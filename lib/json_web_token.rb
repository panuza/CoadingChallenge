class JsonWebToken
  class << self
    def encode(payload, exp = 24.hours.from_now)
      payload[:exp] = exp.to_i
      if Rails.env.production?
        JWT.encode(payload, ENV['SECRET_TOKEN'])
      else
        JWT.encode(payload, Rails.application.secrets.secret_key_base)
      end
    end

    def decode(token)
      if Rails.env.production?
        body = JWT.decode(token, ENV['SECRET_TOKEN'])[0]
      else
        body = JWT.decode(token, Rails.application.secrets.secret_key_base)[0]
      end
      HashWithIndifferentAccess.new body
    rescue
      nil
    end
  end
end
