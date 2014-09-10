require 'rspec'
require_relative '../lib/prototyped_object'

describe PrototypedObject do

  # parte 1

  let :objeto do
    PrototypedObject.new
  end

  context 'set_property' do
    it 'permite definir una nueva propiedad' do
      objeto.set_property(:nueva_propiedad, 100)
      expect(objeto.nueva_propiedad).to eq(100)
      expect(objeto.nueva_propiedad = 200).to eq(200)
    end
    it 'arroja excepcion si no se le asigno la propiedad' do
      expect{objeto.nueva_propiedad}.to raise_error NoMethodError
      expect{objeto.nueva_propiedad = 350}.to raise_error NoMethodError
    end
  end

  context 'set_method' do
    it 'permite definir un nuevo metodo' do
      objeto.set_method(:nombre_metodo, proc {2})
      expect(objeto.nombre_metodo).to eq(2)
    end
    it 'arroja excepcion si no se le asigno el metodo' do
      expect{objeto.nombre_motodo}.to raise_error NoMethodError
    end
  end

  context 'set' do
    it 'permite definir un metodo o propiedad indistintamente' do
      objeto.set(:nueva_propiedad, 15)
      expect(objeto.nueva_propiedad).to eq(15)
      objeto.set(:nuevo_proc, proc { 320 + 1 })
      expect(objeto.nuevo_proc).to eq(321)
      objeto.set(:nuevo_metodo) { 670 + 8 }
      expect(objeto.nuevo_metodo).to eq(678)
    end
    it 'arroja excepcion si no se le asigna un metodo o propiedad' do
      expect{objeto.set(:metodo_o_propiedad)}.to raise_error
    end
  end

  # parte 2

  let :padre do
    PrototypedObject.new
  end
  let :hijo do
    obj = PrototypedObject.new
    obj.set_prototype(padre)
    obj
  end

  context 'un objeto' do
    it 'no posee las propiedades de su prototipo' do
      padre.set_property :propiedad, 100
      expect{hijo.propiedad}.to raise_error NoMethodError
    end
    it 'posee los metodos de su prototipo' do
      padre.set_method :metodo, proc{ 100 }
      expect(hijo.metodo).to eq 100
    end
    it 'no posee las propiedades de sus hijos' do
      hijo.set_property :propiedad, proc{ 100 }
      expect{padre.propiedad}.to raise_error NoMethodError
    end
    it 'no posee los metodos de sus hijos' do
      hijo.set_method :metodo, proc{ 100 }
      expect{padre.metodo}.to raise_error NoMethodError
    end
  end

  it 'verificacion de estados' do
    class Guerrero < PrototypedObject
      attr_accessor :energia
    end

    atila = Guerrero.new
    legolas = Guerrero.new
    atila.energia = 100
    legolas.energia = 20

    atila.set_method(:curarse , proc{ self.energia += 20})

    legolas.set_prototype(atila)


    expect(atila.curarse).to eq(120)
    expect(legolas.curarse).to eq(40)

  end

  # tests de integracion

  it 'prototipos programaticos - parte 1' do
    guerrero = PrototypedObject.new

    guerrero.set_property(:energia, 100)
    expect(guerrero.energia).to eq(100)

    guerrero.set_property(:potencial_defensivo, 10)
    guerrero.set_property(:potencial_ofensivo, 30)
    guerrero.set_method(:atacar_a, proc { |otro_guerrero|
      if(otro_guerrero.potencial_defensivo < self.potencial_ofensivo)
        otro_guerrero.recibe_danio(self.potencial_ofensivo - otro_guerrero.potencial_defensivo)
      end
    })
    guerrero.set_method(:recibe_danio, proc { |danio|
      self.energia = self.energia - danio
    })

    otro_guerrero = guerrero.clone
    guerrero.atacar_a otro_guerrero

    expect(otro_guerrero.energia).to eq(80)

  end

  it 'prototipos programaticos - parte 2' do
    #PARTE 1
    guerrero = PrototypedObject.new

    guerrero.set_property(:energia, 100)
    expect(guerrero.energia).to eq(100)

    guerrero.set_property(:potencial_defensivo, 10)
    guerrero.set_property(:potencial_ofensivo, 30)
    guerrero.set_method(:atacar_a, proc { |otro_guerrero|
      if(otro_guerrero.potencial_defensivo < self.potencial_ofensivo)
        otro_guerrero.recibe_danio(self.potencial_ofensivo - otro_guerrero.potencial_defensivo)
      end
    })
    guerrero.set_method(:recibe_danio, proc { |danio|
      self.energia = self.energia - danio
    })

    otro_guerrero = guerrero.clone
    guerrero.atacar_a otro_guerrero

    expect(otro_guerrero.energia).to eq(80)
    #PARTE 1 FIN

    espadachin = PrototypedObject.new
    espadachin.set_prototype(guerrero)
    espadachin.set_property(:habilidad, 0.5)
    espadachin.set_property(:potencial_espada, 30)
    espadachin.energia = 100
    #{...} #mas inicializaciones
    espadachin.potencial_ofensivo = 0
    #deberia llamar a super, pero eso lo resolvemos mas adelante
    espadachin.set_method(:potencial_ofensivo, proc {
      @potencial_ofensivo + self.potencial_espada * self.habilidad
    })
    espadachin.atacar_a(otro_guerrero)
    expect(otro_guerrero.energia).to eq(75)


  end

  it 'prototipos programaticos - parte 3' do
    #PARTE 1
    guerrero = PrototypedObject.new

    guerrero.set_property(:energia, 100)
    expect(guerrero.energia).to eq(100)

    guerrero.set_property(:potencial_defensivo, 10)
    guerrero.set_property(:potencial_ofensivo, 30)
    guerrero.set_method(:atacar_a, proc { |otro_guerrero|
      if(otro_guerrero.potencial_defensivo < self.potencial_ofensivo)
        otro_guerrero.recibe_danio(self.potencial_ofensivo - otro_guerrero.potencial_defensivo)
      end
    })
    guerrero.set_method(:recibe_danio, proc { |danio|
      self.energia = self.energia - danio
    })

    otro_guerrero = guerrero.clone
    guerrero.atacar_a otro_guerrero

    expect(otro_guerrero.energia).to eq(80)
    #PARTE 1 FIN

    #PARTE 2
    espadachin = PrototypedObject.new
    espadachin.set_prototype(guerrero)
    espadachin.set_property(:habilidad, 0.5)
    espadachin.set_property(:potencial_espada, 30)
    espadachin.energia = 100
    #{...} #mas inicializaciones
    espadachin.potencial_ofensivo = 0
    #deberia llamar a super, pero eso lo resolvemos mas adelante
    espadachin.set_method(:potencial_ofensivo, proc {
      @potencial_ofensivo + self.potencial_espada * self.habilidad
    })
    espadachin.atacar_a(otro_guerrero)
    expect(otro_guerrero.energia).to eq(75)
    #PARTE 2 FIN

    guerrero.set_method(:sanar, proc {
      self.energia = self.energia + 10
    })
    espadachin.sanar
    expect(espadachin.energia).to eq(110)


  end

  it 'prototipos programaticos - parte 4' do
    #PARTE 1
    guerrero = PrototypedObject.new

    guerrero.set_property(:energia, 100)
    expect(guerrero.energia).to eq(100)

    guerrero.set_property(:potencial_defensivo, 10)
    guerrero.set_property(:potencial_ofensivo, 30)
    guerrero.set_method(:atacar_a, proc { |otro_guerrero|
      if(otro_guerrero.potencial_defensivo < self.potencial_ofensivo)
        otro_guerrero.recibe_danio(self.potencial_ofensivo - otro_guerrero.potencial_defensivo)
      end
    })
    guerrero.set_method(:recibe_danio, proc { |danio|
      self.energia = self.energia - danio
    })

    otro_guerrero = guerrero.clone
    guerrero.atacar_a otro_guerrero

    expect(otro_guerrero.energia).to eq(80)
    #PARTE 1 FIN

    #PARTE 2
    espadachin = PrototypedObject.new
    espadachin.set_prototype(guerrero)
    espadachin.set_property(:habilidad, 0.5)
    espadachin.set_property(:potencial_espada, 30)
    espadachin.energia = 100
    #{...} #mas inicializaciones
    espadachin.potencial_ofensivo = 0
    #deberia llamar a super, pero eso lo resolvemos mas adelante
    espadachin.set_method(:potencial_ofensivo, proc {
      @potencial_ofensivo + self.potencial_espada * self.habilidad
    })
    espadachin.atacar_a(otro_guerrero)
    expect(otro_guerrero.energia).to eq(75)
    #PARTE 2 FIN

    #PARTE 3
    guerrero.set_method(:sanar, proc {
      self.energia = self.energia + 10
    })
    espadachin.sanar
    expect(espadachin.energia).to eq(110)
    #PARTE 3 FIN

    expect {otro_guerrero.sanar}.to raise_error(NoMethodError)


  end

end