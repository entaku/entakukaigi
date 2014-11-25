class User

  def initialize
    uuid = UUID.new
    @id = uuid.generate
  end
  attr_reader :id

end