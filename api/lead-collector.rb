require 'grape'
require 'rack/cors'
require 'json'
require 'yaml'

require_relative '../emails/mail_base'

class LeadCollector < Grape::API

  use Rack::Cors do
    allow do
      origins '*'
      resource '*', :headers => :any, :methods => [:get, :options, :put, :post]
    end
  end

  format :json

  post :lead do

    config = YAML.load(File.read(File.dirname(__FILE__) + '/sites.yml'))
    domain = params[:domain]

    fields = config[domain][:fields]

    lead_fields = fields.select { |f| params.has_key?(f) }.map { |f| {field: f, value: params[f]} }

    Leads.post_lead(config[domain][:email], domain, lead_fields, request.ip).deliver

    redirect params[:redirect], permanent: true
  end

  options :lead do

  end

end