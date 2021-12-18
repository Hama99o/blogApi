class ApplicationController < ActionController::API

  def redirect_to_quotes
    redirect_to api_v1_articles_path
  end

  def render_jsonapi_response(resource)
    if resource.errors.empty?
      render jsonapi: resource
    else
      render jsonapi_errors: resource.errors, status: 400
    end
  end
end
