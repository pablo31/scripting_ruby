require_relative 'spec_helper'

describe 'Metamodel' do


  method_name = 'method_name'
  method_name2 = 'method_name2'

  it 'Metamodel sin metodos por default' do

    metamodel = Metamodel.new

    #obtenemos los metodos
    methods = metamodel.get_methods

    #revisamos que no haya ninguno por default
    expect(methods).to be_empty
  end

  it 'Metamodel permite agregar metodos y recuperarlos' do

    #construimos el metamodel con un metodo
    metamodel = Metamodel.new

    block = proc {
        puts 'Cuerpo del bloque'
    }

    metamodel.add_method(method_name, block)

    #revisamos que el metodo haya sido agregado y sea el unico
    expect(metamodel.get_methods.length).to eq(1)
    expect(metamodel.get_method(method_name)).to eq(block)
  end

  it 'Metamodel permite agregar multiples metodos y recuperarlos' do

    #creamos el metamodel
    metamodel = Metamodel.new

    #agregamos el metodo 1
    block = proc {
      puts 'Cuerpo del bloque'
    }

    metamodel.add_method(method_name, block)

    #agregamos el metodo 2
    block2 = proc {
      puts 'Cuerpo del bloque 2'
    }

    metamodel.add_method(method_name2, block2)

    #revisamos que los metodos hayan sido agregados y sean unicos
    expect(metamodel.get_methods.length).to eq(2)
    expect(metamodel.get_method(method_name)).to eq(block)
    expect(metamodel.get_method(method_name2)).to eq(block2)
  end

  it 'Metamodel permite agregar un parent_metamodel con metodos y recuperarlos a traves del hijo' do

    #creamos un metamodel vacio
    metamodel = Metamodel.new

    #creamos un parent_metamodel con un metodo
    parent_metamodel = Metamodel.new

    block = proc {
      puts 'Cuerpo del bloque'
    }
    parent_metamodel.add_method(method_name, block)

    #establecemos la relacion entre los metamodels
    metamodel.parent_metamodel = parent_metamodel


    #verificamos que el metamodel hijo no tenga metodos propios
    expect(metamodel.get_methods.length).to eq(0)

    #verificamos que el metamodel hijo hereda los metodos del padre
    expect(metamodel.get_method(method_name)).to eq(block)
  end


end