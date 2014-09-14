class OptionConstructor < BaseConstructor

  def initialize_object(nuevo_objeto, hash)
    hash.each_pair do |key, value|
      nuevo_objeto.send("#{key}=", value)
    end
  end

  def arguments_needed
    1
  end

end
