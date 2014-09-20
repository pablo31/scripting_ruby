class CopyConstructor < BaseConstructor

  def initialize_object(new_obj)
    self.prototype.instance_variables.each do |variable|
      value = self.prototype.instance_variable_get(variable)
      new_obj.instance_variable_set(variable, value)
    end
  end

  def arguments_needed
    0
  end
end
