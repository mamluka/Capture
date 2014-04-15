require 'grape'
require 'rack/cors'
require 'json'
require 'yaml'
require 'rest-client'
require 'logger'

require_relative '../emails/mail_base'

$logger = Logger.new('lead-log.log')

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

    if config[domain][:telelead] && params.has_key?(:phone)

      phone = params[:phone].scan(/\d/).take(10).join
      response = RestClient.get "https://www.telelead.com/tcpanel/tcpanel/requestcall?uid=b0843ecf-e3d9-4291-9f5c-922dce5ad898&key=0f49e535-ad54-4b61-81c5-3e7f7d1c8ec2&phone=#{phone}"
      $logger.log "Telelead call to: #{phone} result: #{response.body}"
    end

    fields = config[domain][:fields]
    lead_fields = fields.select { |f| params.has_key?(f) }.map { |f| {field: f, value: params[f]} }
    Leads.post_lead(config[domain][:email], domain, lead_fields, request.ip).deliver

    'OK'
  end

  options :lead do

  end

end