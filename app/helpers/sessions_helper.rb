module SessionsHelper
  def friendly_token(length = 20)
    # To calculate real characters, we must perform this operation.
    # See SecureRandom.urlsafe_base64
    rlength = (length * 3) / 4
    SecureRandom.urlsafe_base64(rlength).tr('lIO0', 'sxyz')

  end

  def generate(column)
    key = "DEVISE reset_password_token_generate"
    @digest = "SHA256"

    loop do
      raw = friendly_token
      enc = OpenSSL::HMAC.hexdigest(@digest, key, raw)

      # avoid duplicated reset password token
      break [raw, enc] unless User.find_by({ column => enc })
    end
  end
end
