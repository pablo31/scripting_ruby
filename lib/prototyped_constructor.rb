require_relative 'prototyped_object'
require_relative 'base_constructor'
require_relative 'block_constructor'
require_relative 'option_constructor'
require_relative 'copy_constructor'

class PrototypedConstructor

  def self.new(proto_obj, proc=nil, &block)
    if proc ||= block
      BlockConstructor.new(proto_obj, proc)
    else
      OptionConstructor.new(proto_obj)
    end
  end

  def self.copy(obj)
    CopyConstructor.new(obj)
  end

end
