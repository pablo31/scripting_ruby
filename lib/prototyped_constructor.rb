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
    nuevo_objeto = PrototypedObject.new
    nuevo_objeto.set_prototype(self.prototype)

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


end