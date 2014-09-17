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
      # comentario de ruby: cuando un bloque se llama con "instance_exec" ya no le puedo
      # pasar un bloque implícito (los que tienen el &block) porque ya lo está usando
      # la llamada al instance_exec (conclusión, mis "métodos" no pueden recibir bloques implícitos)
      result = self.instance_exec(*args, &method)
    else

      #refactor del código repetido de abajo: agreguen métodos más descriptivos + quiten la repetición de codigo

      # los strings entienden "end_with?", pero estaría bueno tener un método más descriptivo tipo "es setter" o algo así
      name = name.to_s
      raise(NoMethodError,"No existe el metodo #{name}")  if !es_setter(name)
      value = args[0]
      raise(NoMethodError,"No existe el metodo #{name}") unless value # value? no entiendo esta validación
      name = name.chop # Se elimina el caracter '=' del metodo
      self.set(name, value)
    end

    result
  end

  def es_setter(name)
    name[name.length-1] == "="
  end

  # Constructor que permite asignar diversas variables

  def metamodel
    @metamodel ||= Metamodel.new
  end

  # attr_accessor :metamodel
  def metamodel=(metamodel)
    @metamodel = metamodel
  end

  def parent_metamodel=(parent_metamodel)
    metamodel.parent_metamodel = parent_metamodel
  end

  # El "clone" del tp estaba pensado para que ver que pasaba con el clone de ruby
  # que copia los valores de las variables de intancia.
  # En particular creo que es uno de los puntos menos importantes del tp que, en caso
  # de que complique / conflictúe alguna feature no me preocuparía por eso
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
        # no!!! tirar exceptions abajo de la alfombra es pecado :P

        puts exception.backtrace
        #raise exception # always reraise

        # me gusta el comentario de "always reraise" pero cuando no está comentada la línea :)
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

  def add_prototype proto_obj
    # TODO
  end
end
