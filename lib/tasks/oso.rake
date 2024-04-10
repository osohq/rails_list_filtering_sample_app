namespace :oso do
  desc 'Seeds the Oso Cloud environment with our policy and some data'
  task :seed => :environment do
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
  end
end