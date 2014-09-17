require_relative 'prototyped_object'
require_relative 'base_constructor'
require_relative 'block_constructor'
require_relative 'option_constructor'
require_relative 'copy_constructor'

class PrototypedConstructor

  def self.new(proto_obj, proc=nil, &block)
    # si les molesta que el bloque se pase como parámetro común o como "parametro bloque"
    # pueden cambiar un poco la sintaxis para que siempre se mande de una sola forma
    # (no es muy importante la sintaxis de como paso el bloque)
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
