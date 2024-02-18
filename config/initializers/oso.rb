$oso = OsoCloud::Oso.new(
  url: 'http://localhost:8081',
  api_key: 'e_0123456789_12345_osotesttoken01xiIn',
  data_bindings: Rails.root.join('config', 'oso.yml')
)
$oso.policy(IO.read(Rails.root.join('config', 'oso.polar')))