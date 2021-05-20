class ApplicationController < ActionController::API

  def redirect_to_quotes
    redirect_to api_v1_articles_path
  end
end
