class ListConstructor < BaseConstructor

  attr_accessor :list

  def initialize(proto, list)
    self.prototype = proto
    self.list = list
  end

  def arguments_needed
    self.list.length
  end

  def initialize_object(nuevo_objeto, *args)
    array_asoc = self.list.zip(args)
    array_asoc.each do
      |element|
      atributo = element[0]
      valor = element[1]
      nuevo_objeto.send(atributo.to_s+"=", valor)
    end
  end

end