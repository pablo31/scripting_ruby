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

  def initialize(proto_obj)
    self.prototype = proto_obj
  end

  def new_prototyped_object(prototype)
    nuevo_objeto = PrototypedObject.new
    nuevo_objeto.metamodel = Metamodel.new
    nuevo_objeto.set_prototype(prototype)
    nuevo_objeto
  end

  def extended &block

  end

end

class CopyConstructor < BaseConstructor

  def new
    obj = self.prototype
    new_obj = self.new_prototyped_object(obj)
    obj.instance_variables.each do
    |variable|
      value = obj.instance_variable_get(variable)
      new_obj.instance_variable_set(variable, value)
    end
    new_obj
  end
end

class BlockConstructor < BaseConstructor

  attr_accessor :initialization_block

  def initialize(proto_obj, block)
    self.prototype = proto_obj
    self.initialization_block = block
  end

  def new(*args)
    nuevo_objeto = new_prototyped_object(self.prototype)
    self.initialization_block.call(nuevo_objeto, *args)
    nuevo_objeto
  end

end

class OptionConstructor < BaseConstructor

  def new(*args)
    nuevo_objeto = new_prototyped_object(self.prototype)
    hash = args[0]
    hash.each_pair {
        |key, value|
      nuevo_objeto.send("#{key}=", value)
    }
    nuevo_objeto
  end

end