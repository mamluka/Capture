require 'grape'
require 'rack/cors'

class LeadCollector < Grape::API

  use Rack::Cors do
    allow do
      origins '*'
      resource '*', :headers => :any, :methods => [:get, :options, :put, :post]
    end
  end

  format :json

  post :lead do
    File.open('leads.txt', 'a') { |f| f.puts params[:email] }
    'OK'
  end

  options :lead do

  end

end