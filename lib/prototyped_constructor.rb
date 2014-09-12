require_relative 'metamodel'
require_relative 'prototyped_object'

class PrototypedConstructor

  attr_accessor :prototype
  attr_accessor :inicializacion

  def initialize(proto_obj, *args)
    self.prototype = proto_obj
    bloque = args[0]
    if(bloque)
      self.inicializacion = bloque
    end

  end

  def new(*args)
    nuevo_objeto = new_prototyped_object(self.prototype)

    if(self.inicializacion)
      self.inicializacion.call(nuevo_objeto, *args)
    else
      hash = args[0]
      hash.each_pair {
          |key, value|
        nuevo_objeto.send("#{key}=", value)
      }

    end
    nuevo_objeto
  end

  def new_prototyped_object(prototype)
    nuevo_objeto = PrototypedObject.new
    nuevo_objeto.metamodel = Metamodel.new
    nuevo_objeto.set_prototype(prototype)
    nuevo_objeto
  end

  def self.copy(obj)
    copy_constructor = CopyConstructor.new(obj)
    copy_constructor
  end


end

class CopyConstructor < PrototypedConstructor

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