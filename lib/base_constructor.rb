class BaseConstructor

  attr_accessor :prototype, :super_constructor

  def initialize(proto_obj)
    self.prototype = proto_obj
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

  # solo para marcar / recordar que tengo que implementar este métodos que es "abstracto"
  # (pueden hacer lo mismo con "arguments_needed")
  def initialize_object(nuevo_objeto, *args)
    raise "subclass responsibility"
  end

  def new_prototyped_object(prototype)
    nuevo_objeto = PrototypedObject.new
    # acá hay un code smell porque para inicializar el "prototyped object" hay que
    # setearle un metamodel... yo esperaría que él solo se haga cargo de inicializar su estado
    nuevo_objeto.metamodel = Metamodel.new
    nuevo_objeto.set_prototype(prototype)
    nuevo_objeto
  end

  def extended &block

    #creo el nuevo prototipo
    new_prototype = new_prototyped_object(self.prototype)
    block.call(new_prototype)


    # esta implementación está medio rara...
    # por qué guardan / quitan variables de intancia en un nuevo prototipo?


    #guardo los nuevos atributos en un objeto cualquiera
    prototipo_descartable = PrototypedObject.new
    block.call(prototipo_descartable)
    atributos = prototipo_descartable.instance_variables
    atributos.delete(:@metamodel)


    #creo el nuevo bloque del constructor extendido
    new_block = Proc.new {
        |new_obj, *args|
      array_asoc = atributos.zip(args)
      array_asoc.each do
      |element|
        attribute = element[0]
        value = element[1]
        new_obj.instance_variable_set(attribute, value)
      end
    }
    new_constructor = BlockConstructor.new(new_prototype, new_block)
    new_constructor.super_constructor = self

    new_constructor.define_singleton_method(:arguments_needed, Proc.new{

      self.initialization_block.parameters[1].length

    })

    new_constructor
  end
end
