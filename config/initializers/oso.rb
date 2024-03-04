$oso = OsoCloud::Oso.new(
  url: 'http://localhost:8081',
  api_key: 'e_0123456789_12345_osotesttoken01xiIn',
  data_bindings: Rails.root.join('config', 'oso.yml')
)
$oso.policy(IO.read(Rails.root.join('config', 'oso.polar')))
$oso.tell('has_role',
  OsoCloud::Value.new(type: 'User', id: '0'),
  'owner',
  OsoCloud::Value.new(type: 'Project', id: '0')
)
$oso.tell('has_role',
  OsoCloud::Value.new(type: 'User', id: '1'),
  'owner',
  OsoCloud::Value.new(type: 'Project', id: '1')
)