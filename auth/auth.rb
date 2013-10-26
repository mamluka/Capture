require 'sinatra/base'
require 'omniauth'
require 'omniauth-facebook'
require 'omniauth-google-oauth2'
require 'securerandom'
require 'yaml'
require 'rack/cors'

$config = YAML.load(File.read(File.dirname(__FILE__) + '/auth.yml'))

#OmniAuth.config.full_host = $config[:callback_base_url]

class Auth < Sinatra::Base
  use Rack::Session::Cookie, :secret => $config[:cookie_secret]

  use OmniAuth::Builder do
    provider :facebook, $config[:facebook][:key], $config[:facebook][:secret]
    provider :google_oauth2, $config[:google_oauth2][:key], $config[:google_oauth2][:secret]
  end

  use Rack::Cors do
    allow do
      origins '*'
      resource '*', :headers => :any, :methods => [:get, :options, :put, :post]
    end
  end

  get '/auth/:provider/callback' do
    auth = request.env['omniauth.auth']
    user_id = auth['info']['email']

    session[:user_id] = user_id
    session[:first_name] = auth['info']['first_name']
    session[:last_name] = auth['info']['last_name']

    redirect to($config[:domain])
  end

  get '/test' do
    'ok'
  end

end