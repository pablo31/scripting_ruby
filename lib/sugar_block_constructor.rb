class SugarBlockConstructor < BlockConstructor

  def initialize_object(nuevo_objeto, *args)
    nuevo_objeto.instance_exec(*args, &self.initialization_block)
  end

  def arguments_needed
    self.initialization_block.parameters.length
  end

end