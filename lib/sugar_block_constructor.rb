class SugarBlockConstructor < BlockConstructor

  def initialize_object(nuevo_objeto, *args)
    nuevo_objeto.instance_exec(*args, &self.initialization_block)
  end

  def arguments_needed
    self.initialization_block.parameters.length
  end

  def with &block
    if block_given?
      self.initialization_block = block
    end
    self
  end

  def with_properties(list)
    nuevo_constructor = ListConstructor.new(self.prototype, list)
    nuevo_constructor
  end

end