require_relative 'spec_helper'

describe 'Azucar Sintactico' do

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


  it 'Parte 2' do
    guerrero_proto = PrototypedObject.new {
      self.energia = 100
      self.potencial_ofensivo = 30
      self.potencial_defensivo = 10
      self.atacar_a = proc {|otro_guerrero|
        if(otro_guerrero.potencial_defensivo < self.potencial_ofensivo)
          otro_guerrero.recibe_danio(self.potencial_ofensivo - otro_guerrero.potencial_defensivo)
        end}
      self.recibe_danio = proc { |danio|
        self.energia = self.energia - danio}
    }

    # Se controla que se hayan asignado todos los atributos
    expect(guerrero_proto.energia).to eq(100)
    expect(guerrero_proto.potencial_ofensivo).to eq(30)
    expect(guerrero_proto.potencial_defensivo).to eq(10)

    # Se controla que se hayan asignado los métodos 'atacar_a' y 'recibe_danio' y que devuelve lo que corresponde.
    otro_guerrero = guerrero_proto.clone
    expect(otro_guerrero.atacar_a(guerrero_proto)).to eq(80)
  end

  it 'Parte 3' do

    guerrero = PrototypedObject.new
    guerrero_constructor = PrototypedConstructor.new(guerrero) do |una_energia, un_potencial_ofensivo,
        un_potencial_defensivo|
      self.energia = una_energia
      self.potencial_ofensivo = un_potencial_ofensivo
      self.potencial_defensivo = un_potencial_defensivo
    end

    un_guerrero = guerrero_constructor.new(100, 30, 10)
    expect(un_guerrero.energia).to eq(100)
  end

  it 'Parte 4' do

    guerrero_constructor = PrototypedConstructor.create {
      self.atacar_a = proc {|otro_guerrero|
        if(otro_guerrero.potencial_defensivo < self.potencial_ofensivo)
          otro_guerrero.recibe_danio(self.potencial_ofensivo - otro_guerrero.potencial_defensivo)
        end}
      self.recibe_danio = proc { |danio| self.energia = self.energia - danio}
    }.with {
        |una_energia, un_potencial_ofensivo, un_potencial_defensivo|
      self.energia = una_energia
      self.potencial_ofensivo = un_potencial_ofensivo
      self.potencial_defensivo = un_potencial_defensivo
    }

    guerrero = guerrero_constructor.new(100, 30, 10)
    expect(guerrero.energia).to eq(100)

  end

  it 'Parte 5' do
    guerrero_constructor = PrototypedConstructor.create {
      atacar_a = proc {|otro_guerrero|
        if(otro_guerrero.potencial_defensivo < self.potencial_ofensivo)
          otro_guerrero.recibe_danio(self.potencial_ofensivo - otro_guerrero.potencial_defensivo)
        end}
      recibe_danio = proc { |danio| self.energia = self.energia - danio}
    }.with_properties([:energia, :potencial_ofensivo, :potencial_defensivo])

    guerrero = guerrero_constructor.new(100, 30, 10)
    expect(guerrero.energia).to eq(100)
  end

  it 'Parte 6' do

    #Uso un list constructor pero podria usar cualquiera
    guerrero_constructor = PrototypedConstructor.create {
      self.atacar_a = proc {|otro_guerrero|
        if(otro_guerrero.potencial_defensivo < self.potencial_ofensivo)
          otro_guerrero.recibe_danio(self.potencial_ofensivo - otro_guerrero.potencial_defensivo)
        end}
      self.recibe_danio = proc { |danio| self.energia = self.energia - danio}
    }.with_properties([:energia, :potencial_ofensivo, :potencial_defensivo])


    atila = guerrero_constructor.new(100, 50, 30)
    expect(atila.potencial_ofensivo).to eq(50)
    proto_guerrero = guerrero_constructor.prototype
    proto_guerrero.potencial_ofensivo = proc {
      1000
    }

    expect(atila.potencial_ofensivo).to eq(1000)

  end

  it 'Parte 7' do

    guerrero = PrototypedObject.new
    guerrero.set_property(:energia, 100)
    guerrero.set_property(:potencial_defensivo, 10)
    guerrero.set_property(:potencial_ofensivo, 30)

    guerrero_constructor = PrototypedConstructor.new(guerrero, proc {
        |guerrero_nuevo, una_energia, un_potencial_ofensivo, un_potencial_defensivo|
      guerrero_nuevo.energia = una_energia
      guerrero_nuevo.potencial_ofensivo = un_potencial_ofensivo
      guerrero_nuevo.potencial_defensivo = un_potencial_defensivo
    })

    espadachin_constructor = guerrero_constructor.extended {
        |una_habilidad, un_potencial_espada|
      self.habilidad = una_habilidad
      self.potencial_espada = un_potencial_espada
      self.potencial_ofensivo = proc {
        @potencial_ofensivo + self.potencial_espada * self.habilidad
      }
    }

    espadachin = espadachin_constructor.new(100, 30, 10, 0.5, 30)
    expect(espadachin.habilidad).to eq(0.5)

  end

end