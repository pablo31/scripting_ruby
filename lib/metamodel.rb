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
