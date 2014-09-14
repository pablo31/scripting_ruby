require_relative 'metamodel'

class PrototypedObject

  # Logica inicial

  def set_method name, block
    metamodel.add_method name.to_sym, block
  end

  def set_property name, value
    self.instance_variable_set("@#{name}", value)
    
    self.set_method(name, proc {
      self.instance_variable_get("@#{name}")
    })

    self.set_method("#{name}=".to_sym, proc { |new_value|
      self.instance_variable_set("@#{name}", new_value)
    })
  end

  def set_prototype obj
    self.parent_metamodel = obj.metamodel
  end

  # Para ver mas adelante: funcion que setea una variable o metodo indistintamente

  def set name, value=nil, &block
    value ||= block
    raise('Se debe especificar un valor o bloque de codigo para la asignacion') unless value
    if value.is_a? Proc
      set_method(name, value)
    else
      set_property(name, value)
    end
  end

  # Asignacion "a la javascript"

  def method_missing name, *args, &block
    method = metamodel.get_method name.to_sym

    if(method)
      result = self.instance_exec(*args, &method)
    else
      name = name.to_s
      raise(NoMethodError,"No existe el metodo #{name}")  if name[name.length-1] != "="
      value = args[0]
      raise(NoMethodError,"No existe el metodo #{name}") unless value
      name = name.chop # Se elimina el caracter '=' del metodo
      self.set(name, value)
    end

    result
  end

  # Constructor que permite asignar diversas variables

  def metamodel
    @metamodel ||= Metamodel.new
  end

  def metamodel=(metamodel)
    @metamodel = metamodel
  end

  def parent_metamodel=(parent_metamodel)
    metamodel.parent_metamodel = parent_metamodel
  end

  def clone
    create_clone self
  end

  def create_clone(obj)

    created_clone = PrototypedObject.new
    obj.instance_variables
    obj.instance_variables.each do |ivar_name|
      begin
        value = obj.instance_variable_get(ivar_name)
        #if(value)
        #  value = value.clone
        #end
        if(ivar_name != @metamodel)
          created_clone.instance_variable_set(
              ivar_name,
              value)
        end
      rescue => exception
        puts exception.backtrace
        #raise exception # always reraise
      end

    end

    created_clone.metamodel = obj.metamodel.clone

    created_clone
  end

  def initialize &block
    super
    if block_given?
      self.instance_eval(&block)
    end
    self
  end
end
