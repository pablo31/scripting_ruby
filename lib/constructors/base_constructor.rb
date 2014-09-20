class BaseConstructor

  attr_accessor :prototype, :super_constructor

  def initialize(prototype)
    self.prototype = prototype
  end

  def new(*args)
    obj = PrototypedObject.new
    obj.set_prototype(self.prototype)
    self.initialize_object(obj, *args)
    obj
  end

  def extended &block
    ExtendedConstructor.new self, &block
  end

end
