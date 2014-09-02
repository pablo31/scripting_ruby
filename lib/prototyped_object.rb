class PrototypedObject

  # Logica inicial

  def set_property name, value
    # TODO
  end

  def set_method name, block
    # TODO
  end

  def set_prototype obj
    # TODO
  end

  # Para ver mas adelante: funcion que setea una variable o metodo indistintamente

  # def set name, value, &block
  #   define_method(name, &block) and return if block_given?
  #   # TODO
  # end

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
