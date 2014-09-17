class BlockConstructor < BaseConstructor

  # detalle de ruby, los attr_accessor se pueden separar por ","
  attr_accessor :initialization_block, :super_constructor

  def initialize(proto_obj, block)
    self.prototype = proto_obj
    self.initialization_block = block
  end

  def initialize_object(nuevo_objeto, *args)
      self.initialization_block.call(nuevo_objeto, *args)
  end

  def arguments_needed
    # otro mensaje interesante es "arity"
    (self.initialization_block.parameters.length) -1
  end

end
