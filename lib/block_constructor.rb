class BlockConstructor < BaseConstructor

  attr_accessor :initialization_block
  attr_accessor :super_constructor

  def initialize(proto_obj, block)
    self.prototype = proto_obj
    self.initialization_block = block
  end

  def initialize_object(nuevo_objeto, *args)
      self.initialization_block.call(nuevo_objeto, *args)
  end

  def arguments_needed
    (self.initialization_block.parameters.length) -1
  end

end
