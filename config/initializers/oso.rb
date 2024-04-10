$oso = OsoCloud::Oso.new(
  api_key: ENV['OSO_AUTH'],
  data_bindings: Rails.root.join('config', 'oso.yml')
)