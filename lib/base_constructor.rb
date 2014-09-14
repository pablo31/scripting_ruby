class BaseConstructor

  attr_accessor :prototype
  attr_accessor :super_constructor

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

  def extended &block
    new_prototype = self.prototype.clone
    #block.call(new_prototype)
    new_constructor = BlockConstructor.new(new_prototype, block)
    new_constructor.super_constructor = self
    new_constructor
  end
end
