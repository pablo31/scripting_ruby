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

    metamodel_list.each { |current_metamodel|

      if (!method and current_metamodel)
        method = current_metamodel.get_method name
      end

      break if method
    }

    method
  end

  def parent_metamodel=(parent)
    metamodel_list.clear
    metamodel_list << parent
  end

  def metamodel_list
    if(!@metamodel_list)
      @metamodel_list = []
    end
    @metamodel_list
  end

  def clone
    cloned_metamodel = Metamodel.new

    get_methods.each do |key, method|
      cloned_metamodel.add_method(key, method)
    end

    cloned_metamodel
  end

  def set_prototypes(proto_array)
    metamodel_list.clear
    proto_array.reverse.each { |parent|
      if(parent.is_a?(Metamodel))
        metamodel_list << parent
      elsif(parent.is_a?(PrototypedObject))
        metamodel_list << parent.metamodel
      end
    }

  end
end
