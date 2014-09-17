class CopyConstructor < BaseConstructor

  def initialize_object(new_obj)

    # esto de copiar las variables de instancia está de la mano del clone,
    # no repitan ese código / vean si el nativo de ruby no les sirve

    self.prototype.instance_variables.each do |variable|
      value = self.prototype.instance_variable_get(variable)
      new_obj.instance_variable_set(variable, value)
    end
  end

  def arguments_needed
    0
  end
end
