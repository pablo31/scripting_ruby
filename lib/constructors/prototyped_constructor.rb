class PrototypedConstructor

  def self.new(proto_obj, proc=nil, &block)
    if proc.is_a?(Proc)
      BlockConstructor.new(proto_obj, proc)
    elsif block_given?
      SugarBlockConstructor.new(proto_obj, block)
    else
      OptionConstructor.new(proto_obj)
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
