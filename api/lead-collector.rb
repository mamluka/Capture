require 'grape'
require 'rack/cors'
require 'json'

class LeadCollector < Grape::API

  use Rack::Cors do
    allow do
      origins '*'
      resource '*', :headers => :any, :methods => [:get, :options, :put, :post]
    end
  end

  format :json

  post :lead do
    File.open('leads.txt', 'a') { |f| f.puts JSON.pretty_generate(params) }
    redirect params[:redirect], permanent: true
  end

  options :lead do

  end

end