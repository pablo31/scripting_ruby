class ExtendedConstructor
  attr_accessor :decorated
  attr_accessor :block

  def initialize(decorated, &block)
    self.decorated = decorated
    self.block = block
  end

  def new *args
    obj = decorated.new *args
    args_count = args.size - decorated.arguments_needed
    extended_args = args.last(args_count)
    block.call(obj, *extended_args)
    obj
  end

end

# (c) 2014