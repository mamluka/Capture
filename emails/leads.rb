class Leads < EmailBase

  def post_lead(email, domain, fields,ip)
    @domain = domain
    @fields = fields
    @ip = ip

    prepare_email to: email, subject: 'A new lead was posted'
  end
end