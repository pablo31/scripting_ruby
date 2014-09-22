module Prototyped

  # Logica inicial

  def set_method name, block
    prototyped_methods[name.to_sym] = PrototypeMethod.new(name, block, self)
  end

  def set_property name, value
    self.instance_variable_set("@#{name}", value)
    
    self.set_method(name, proc {
      self.instance_variable_get("@#{name}")
    })

    self.set_method("#{name}=".to_sym, proc { |new_value|
      set_method(name, new_value) if new_value.is_a?(Proc) #Ver parte 6 de azucar_sintactico_spec (porque asi es una cagada)
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

    method = get_method method_name

    if(method)
      result = method_executor.execute(self, method, args)
    else
      name = method_name.to_s
      super if !name.end_with?("=") && !block_given?
      value = args[0] || block
      super unless value
      name = name.gsub('=', '') # Se elimina el caracter '=' del metodo
      self.set(name, value)
    end

    result
  end

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

  def get_next_method(method_caller)

    own_method= prototyped_methods[method_caller.name.to_sym]

    if(own_method == method_caller)
      own_method = nil
    end
    method = nil

    prototypes_list.each do |parent|
      method = parent.prototyped_methods[method_caller.name.to_sym]

      # orden 1
      if(method == method_caller)
        method = nil
      end

      if(!method)
        method = parent.get_next_method(method_caller)
      end

      #orden 2
      # method = parent.get_next_method(method_caller)
      #
      # if(method == method_caller)
      #   method = nil
      # end
      #
      # if(!method)
      #   method = parent.prototyped_methods[method_caller.name.to_sym]
      # end

      break if method and method != method_caller
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

  def method_executor
    @method_executor ||= MethodExecutor.new
  end

  def call_next *args
    prototype_method = method_executor.current_executing_method
    raise(StandardError, 'No se puede ejecutar call_next fuera de un metodo de instancia') unless prototype_method

    method = get_next_method(prototype_method)
    raise(NoMethodError, "No se encontro el metodo ´#{prototype_method.name}´") unless method

    # self.instance_exec &method.block
    method_executor.execute(self, method, args)
  end


end

class PrototypeMethod

  attr_accessor :name, :block, :prototype

  def initialize(name, block, prototype)
    @name = name
    @block = block
    @prototype = prototype
  end

end

class MethodExecutor
  def executing_method_stack
    @executing_method_stack ||= Array.new
  end

  def current_executing_method
    executing_method_stack.last
  end


  def execute(instance, method, args)
    begin
      self.executing_method_stack.push method
      instance.instance_exec(*args, &method.block)
    ensure
      self.executing_method_stack.pop
    end
  end

end
