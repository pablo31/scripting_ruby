class PrototypedObject

  # Logica inicial

  def set_method name, block
    prototyped_methods[name.to_sym] = block
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

  def set_prototype prototype
    prototypes_list.clear
    prototypes_list << prototype
  end

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

  def method_missing method_name, *args, &block


    self.executing_method_stack.push method_name

    method = get_method method_name

    if(method)
      result = self.instance_exec(*args, &method)
    else
      name = method_name.to_s
      super if name[name.length-1] != "=" && !block_given?
      value = args[0] || block
      super unless value
      name = name.gsub('=', '') # Se elimina el caracter '=' del metodo
      self.set(name, value)
    end
    self.executing_method_stack.pop

    result
  end

  # def clone
  #   created_clone = PrototypedObject.new
  #   self.instance_variables
  #   self.instance_variables.each do |ivar_name|
  #     begin
  #       value = self.instance_variable_get(ivar_name)
  #       #if(value)
  #       #  value = value.clone
  #       #end
  #       if(ivar_name != @metamodel)
  #         created_clone.instance_variable_set(
  #             ivar_name,
  #             value)
  #       end
  #     rescue => exception
  #       puts exception.backtrace
  #       #raise exception # always reraise
  #     end

  #   end
  #   created_clone.metamodel = self.metamodel.clone
  #   created_clone
  # end

  def initialize &block
    super
    self.instance_eval(&block) if block_given?
  end

  # ex metamodel

  def get_method(name)
    prototyped_methods[name.to_sym] || get_prototype_method(name)
  end

  def get_prototype_method(name)
    method = nil
    prototypes_list.each do |parent|
      method = parent.get_method name
      break if method
    end

    method
  end

  def set_prototypes(proto_array)
    prototypes_list.clear
    proto_array.reverse.each do |parent|
      prototypes_list << parent
    end
  end

  def prototyped_methods
    @methods ||= Hash.new
  end

  def prototypes_list
    @prototypes_list ||= Array.new
  end

  def call_next
    method_name = executing_method_stack.last
    method = get_prototype_method(method_name)

    if(!method)
      raise NoMethodError, "No se encontro el metodo ´#{name}´"
    end

    self.instance_exec &method
  end

  def executing_method_stack
    @executing_method_stack ||= Array.new
  end

end
