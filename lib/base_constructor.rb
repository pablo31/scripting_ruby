class BaseConstructor

  attr_accessor :prototype
  attr_accessor :super_constructor

  def initialize(prototype)
    self.prototype = prototype
  end

  def new(*args)
    obj = PrototypedObject.new
    obj.set_prototype(self.prototype)
    initialization(obj, *args)
    obj
  end

  def initialization(new_obj, *args)
    if(super_constructor)
      arguments_needed = self.arguments_needed
      arguments_total = args.length
      self_arguments = args.drop(arguments_total - arguments_needed)
      self.initialize_object(new_obj, *self_arguments)
      super_arguments = args.take(arguments_total - arguments_needed)
      super_constructor.initialize_object(new_obj, *super_arguments)
    else
      self.initialize_object(new_obj, *args)
    end
  end

  def new_prototyped_object(prototype)
    nuevo_objeto = PrototypedObject.new
    nuevo_objeto.set_prototype(prototype)
    nuevo_objeto
  end

  def extended &block
    #creo el nuevo prototipo
    new_prototype = new_prototyped_object(self.prototype)
    block.call(new_prototype)

    #guardo los nuevos atributos en un objeto cualquiera
    prototipo_descartable = PrototypedObject.new
    block.call(prototipo_descartable)
    nuevos_atributos = prototipo_descartable.instance_variables
    nuevos_atributos.delete(:@methods)
    nuevos_atributos.delete(:@prototypes_list)

    #creo el nuevo bloque del constructor extendido
    new_block = proc do |new_obj, *args|
      array_asoc = nuevos_atributos.zip(args)
      array_asoc.each do |element|
        attribute = element[0]
        value = element[1]
        new_obj.instance_variable_set(attribute, value)
      end
    end
    new_constructor = BlockConstructor.new(new_prototype, new_block)
    new_constructor.super_constructor = self

    new_constructor.define_singleton_method(:arguments_needed, proc {
      self.initialization_block.parameters[1].length
    })

    new_constructor
  end
end
