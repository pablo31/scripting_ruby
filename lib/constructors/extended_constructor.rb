class ExtendedConstructor
  attr_accessor :decorated
  attr_accessor :block

  def initialize(decorated, &block)
    self.decorated = decorated
    self.block = block
  end

  def new *args
    args_count = decorated.arguments_needed
    decorated_args = args.first(args_count)
    extended_args = args.last(args.size - args_count)
    obj = decorated.new *decorated_args
    if block.arity == extended_args.size
      obj.instance_exec(*extended_args, &block)
    else
      block.call(obj, *extended_args)
    end
    obj
  end

end
