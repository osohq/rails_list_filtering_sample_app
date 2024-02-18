class User < OsoCloud::Value
  attr_reader :name

  def initialize(id:, name:)
    super(id: id, type: 'User')
    @name = name
  end
end