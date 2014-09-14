require 'rspec'
require_relative '../lib/prototyped_constructor'

describe 'Azucar Sintactico' do

  it 'Setear una variable' do

    guerrero_proto = PrototypedObject.new
    guerrero_proto.energia = 100
    expect(guerrero_proto.energia).to eq(100)

  end

  it 'Setear un método' do
    guerrero_proto = PrototypedObject.new
    guerrero_proto.energia = 100
    guerrero_proto.reducir_energia = proc {self.energia = self.energia - 20}
    expect(guerrero_proto.reducir_energia).to eq(80)
  end

  it 'Parte 1' do
    guerrero_proto = PrototypedObject.new
    guerrero_proto.energia = 100
    expect(guerrero_proto.energia).to eq(100)
    guerrero_proto.potencial_defensivo = 10
    guerrero_proto.potencial_ofensivo = 30
    guerrero_proto.atacar_a = proc { |otro_guerrero|
      if(otro_guerrero.potencial_defensivo < self.potencial_ofensivo)
        otro_guerrero.recibe_danio(self.potencial_ofensivo - otro_guerrero.potencial_defensivo)
      end}
    guerrero_proto.recibe_danio =  proc { |danio|
      self.energia = self.energia - danio}

    Guerrero = PrototypedConstructor.copy(guerrero_proto)
    un_guerrero = Guerrero.new
    Guerrero.new.atacar_a(un_guerrero)
    expect(un_guerrero.energia).to eq(80)
  end

end