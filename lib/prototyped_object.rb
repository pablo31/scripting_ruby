class PrototypedObject

  # Logica inicial

  def set_property name, value
    self.instance_variable_set("@#{name}", value)
    crear_getter_y_setter(name)
  end

  def crear_getter_y_setter(name)
    self.set_method(name, proc { self.instance_variable_get("@#{name}") })

    self.set_method("#{name}=", proc { |valor|
      self.instance_variable_set("@#{name}", valor)
    })
  end

  def set_method name, block
    self.define_singleton_method(name, block)
  end

  def set_prototype obj
    # TODO
  end

  # Para ver mas adelante: funcion que setea una variable o metodo indistintamente

  def set name, value=nil, &block
    value ||= block
    raise('Se debe especificar un valor o bloque de codigo para la asignacion') unless value
    value.is_a?(Proc) ? set_method(name, value) : set_property(name, value)
  end

  # Asignacion "a la javascript"

  def method_missing name, *args, &block
    # TODO
    super
  end

  # Constructor que permite asignar diversas variables

  def initialize &block
    # instance_exec self, block
    # TODO
  end

end

# class Object
#   include PrototypedObject
# end
