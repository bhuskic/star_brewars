module AuthHelper
  def add_token token
    request.env['HTTP_AUTHORIZATION'] =
      ActionController::HttpAuthentication::Token.encode_credentials(
        "#{token}")
  end
end
