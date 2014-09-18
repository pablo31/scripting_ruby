require_relative 'spec_helper'

describe PrototypedObject do

  # parte 1

  context 'set_property' do
    let :objeto do
      PrototypedObject.new
    end
    it 'permite definir una nueva propiedad' do
      objeto.set_property(:nueva_propiedad, 100)
      expect(objeto.nueva_propiedad).to eq(100)
      expect(objeto.nueva_propiedad = 200).to eq(200)
    end
  end

  context 'set_method' do
    let(:objeto){ PrototypedObject.new }
    it 'permite definir un nuevo metodo' do
      objeto.set_method(:nombre_metodo, proc {2})
      expect(objeto.nombre_metodo).to eq(2)
    end
    it 'arroja excepcion si no se le asigno el metodo' do
      expect{objeto.nombre_motodo}.to raise_error NoMethodError
    end
  end

  context 'set' do
    let(:objeto){ PrototypedObject.new }
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

  context 'un objeto' do
    let :padre do
      PrototypedObject.new
    end
    let :hijo do
      obj = PrototypedObject.new
      obj.set_prototype(padre)
      obj
    end
    it 'posee las propiedades de su prototipo' do
      padre.set_property :propiedad, 100
      hijo.propiedad = 20
      expect(hijo.propiedad).to eq(20)
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
    it 'no posee el estado de su padre' do
      padre.set_property :propiedad, 100
      hijo.propiedad = 20
      expect(padre.propiedad).to eq(100)
      expect(hijo.propiedad).to eq(20)
    end
  end

  # tests de azucar sintactico

  context 'la asignacion a la javascript' do
    let :objeto do
      PrototypedObject.new
    end
    it 'permite definir una nueva propiedad' do
      objeto.nueva_propiedad = 100
      expect(objeto.nueva_propiedad).to eq 100
    end
    it 'permite definir un nuevo metodo' do
      objeto.nombre_metodo { 2 }
      expect(objeto.nombre_metodo).to eq 2
    end
    it 'no asume que algo no definido sea nil' do
      expect{objeto.metodo_inexistente}.to raise_error NoMethodError
    end
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
  end

  context 'un objeto con multiples prototipos' do
    let :first_parent do
      PrototypedObject.new
    end
    let :last_parent do
      PrototypedObject.new
    end
    let :object do
      obj = PrototypedObject.new
      obj.set_prototypes([first_parent, last_parent])
      obj
    end
    it 'busca el metodo en sus prototipos' do
      last_parent.set(:metodo, proc { 10 })
      expect(object.metodo).to eq(10)
    end
    
    it 'llama al metodo de su ultimo prototipo agregado' do
      first_parent.set(:metodo, proc { 10 })
      last_parent.set(:metodo, proc { 20 })
      expect(object.metodo).to eq(20)
    end
    it 'falla si ninguno de sus prototipos posee el metodo' do
      expect{object.metodo}.to raise_error NoMethodError
    end
  end

  context 'call_next' do
    let :parent do
      PrototypedObject.new
    end
    let :object do
      obj = PrototypedObject.new
      obj.set_prototype(parent)
      obj
    end
    it 'permite llamar al metodo de su prototipo' do
      parent.set(:metodo, proc { 10 })
      object.set(:metodo, proc { 5 + call_next(:metodo) })
      expect(object.metodo).to eq(15)
    end
    it 'no depende del estado interno del padre' do
      parent.set(:propiedad, 10)
      parent.set(:metodo, proc { self.propiedad })
      object.set(:propiedad, 15)
      object.set(:metodo, proc { 5 + call_next(:metodo) })
      expect(object.metodo).to eq(20)
    end
    # it 'arroja error si el padre no posee el metodo' do
    #   object.set(:metodo, proc { call_next(:metodo) })
    #   expect{object.metodo}.to raise_error NoMethodError
    # end
  end
end