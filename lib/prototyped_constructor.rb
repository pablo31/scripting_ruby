require_relative 'prototyped_object'
require_relative 'base_constructor'
require_relative 'block_constructor'
require_relative 'option_constructor'
require_relative 'copy_constructor'
require_relative 'sugar_block_constructor'

class PrototypedConstructor

  def self.new(proto_obj, proc=nil, &block)
      if proc.is_a?(Proc)
        BlockConstructor.new(proto_obj, proc)
      else if block_given?
             SugarBlockConstructor.new(proto_obj, block)
           else
             OptionConstructor.new(proto_obj)
           end
      end


  end

  def self.copy(obj)
    CopyConstructor.new(obj)
  end

  def self.create &block
    new_proto = PrototypedObject.new
    new_proto.instance_eval &block
    nuevo_constructor = SugarBlockConstructor.new(new_proto, nil)
    nuevo_constructor
  end

end
