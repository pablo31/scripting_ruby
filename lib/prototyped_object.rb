class PrototypedObject

  # Logica inicial

  def set_property name, value
    self.instance_variable_set("@#{name}", value)

    crear_getter_y_setter(name)

  end

  def crear_getter_y_setter(name)
    self.set_method(name, proc { self.instance_variable_get("@#{name}") })

    self.set_method("#{name}=".to_sym, proc {
        |valor|
      self.instance_variable_set("@#{name}", valor)
    })

  end

  def set_method name, block
    #self.define_singleton_method(name, block)
    metamodel.add_method name, block
  end

  def set_prototype obj
    self.parent_metamodel = obj.metamodel
  end

  # Para ver mas adelante: funcion que setea una variable o metodo indistintamente

  # def set name, value, &block
  #   define_method(name, &block) and return if block_given?
  #   # TODO
  # end

  # Asignacion "a la javascript"

  def method_missing name, *args, &block
    # TODO
    method = metamodel.get_method name.to_sym

    if(method)
      result = self.instance_exec(*args, &method)
    else
      raise NoMethodError
    end

    result
  end

  # Constructor que permite asignar diversas variables

  def initialize &block
    # instance_exec self, block
    # TODO

  end

  def metamodel
    if(!@metamodel)
      @metamodel = Metamodel.new
    end
    @metamodel
  end

  def metamodel=(metamodel)
    @metamodel= metamodel
  end

  def parent_metamodel=(parent_metamodel)
    metamodel.parent_metamodel= parent_metamodel
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
end


# class Object
#   include PrototypedObject
# end


class Metamodel

  def add_method(name, block)
    get_methods[name] = block
  end

  def get_methods
    if !@methods
      @methods = Hash.new
    end
    @methods
  end

  def get_method(name)
    method = get_methods[name]

    if (!method and parent_metamodel)
      method = parent_metamodel.get_method name
    end

    method
  end

  def parent_metamodel=(parent_metamodel)
    @parent_metamodel = parent_metamodel
  end

  def parent_metamodel
    @parent_metamodel
  end

  def clone
    cloned_metamodel = Metamodel.new

    get_methods.each do |key, method|
      cloned_metamodel.add_method(key, method)
    end

    cloned_metamodel
  end
end