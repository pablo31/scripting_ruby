require_relative 'metamodel'
require_relative 'prototyped_object'

class PrototypedConstructor

  def self.new(proto_obj, *args)

    bloque = args[0]
    if(bloque)
      new_constructor = BlockConstructor.new(proto_obj, bloque)
    else
      new_constructor = OptionConstructor.new(proto_obj)
    end
    new_constructor
  end

  def self.copy(obj)
    copy_constructor = CopyConstructor.new(obj)
    copy_constructor
  end

end

class BaseConstructor

  attr_accessor :prototype
  attr_accessor :super_constructor

  def initialize(proto_obj)
    self.prototype = proto_obj
  end

  def new_prototyped_object(prototype)
    nuevo_objeto = PrototypedObject.new
    nuevo_objeto.set_prototype(prototype)
    nuevo_objeto
  end

  def new(*args)
    nuevo_objeto = self.new_prototyped_object(self.prototype)
    initialization(nuevo_objeto, *args)
    nuevo_objeto
  end

  def initialization(nuevo_objeto, *args)

    if(super_constructor)
      arguments_needed = self.arguments_needed
     arguments_total = args.length
     self_arguments = args.drop(arguments_total - arguments_needed)
     self.initialize_object(nuevo_objeto, *self_arguments)
     super_arguments = args.take(arguments_total - arguments_needed)
     super_constructor.initialize_object(nuevo_objeto, *super_arguments)
    else
      self.initialize_object(nuevo_objeto, *args)
    end

  end

  def extended &block
    new_prototype = self.prototype.clone
    #block.call(new_prototype)
    new_constructor = BlockConstructor.new(new_prototype, block)
    new_constructor.super_constructor = self
    new_constructor
  end
end

class CopyConstructor < BaseConstructor

  def initialize_object(new_obj)
    self.prototype.instance_variables.each do
    |variable|
      value = self.prototype.instance_variable_get(variable)
      new_obj.instance_variable_set(variable, value)
    end
  end

  def arguments_needed
    0
  end
end

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

class OptionConstructor < BaseConstructor

  def initialize_object(nuevo_objeto, *args)
    hash = args[0]
    hash.each_pair {
        |key, value|
      nuevo_objeto.send("#{key}=", value)
    }
  end

  def arguments_needed
    1
  end

end