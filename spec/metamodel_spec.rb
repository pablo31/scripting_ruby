require_relative 'spec_helper'

describe 'Metamodel' do

  it 'PrototypedObject sin metodos por default' do

    object = PrototypedObject.new

    #obtenemos los metodos
    methods = object.prototyped_methods

    #revisamos que no haya ninguno por default
    expect(methods).to be_empty
  end

  it 'PrototypedObject permite agregar metodos y recuperarlos' do

    #construimos el metamodel con un metodo
    object = PrototypedObject.new

    block = proc { u cant touch this }
    object.set_method('a_method', block)

    #revisamos que el metodo haya sido agregado y sea el unico
    expect(object.prototyped_methods.length).to eq(1)
    expect(object.get_method('a_method').block).to eq(block)
  end

  it 'PrototypedObject permite agregar multiples metodos y recuperarlos' do

    #creamos el metamodel
    object = PrototypedObject.new

    #agregamos el metodo 1
    a_block = proc { hi! im a block }
    object.set_method('a_method', a_block)

    #agregamos el metodo 2
    another_block = proc { hi! im another block }
    object.set_method('another_method', another_block)

    #revisamos que los metodos hayan sido agregados y sean unicos
    expect(object.prototyped_methods.length).to eq(2)
    expect(object.get_method('a_method').block).to eq(a_block)
    expect(object.get_method('another_method').block).to eq(another_block)
  end

  it 'PrototypedObject permite agregar un parent_metamodel con metodos y recuperarlos a traves del hijo' do
    father = PrototypedObject.new
    son = PrototypedObject.new

    block = proc { ruby blocks rlz }
    father.set_method('a_method', block)

    #establecemos la relacion entre los metamodels
    son.set_prototype(father)

    #verificamos que el metamodel hijo no tenga metodos propios
    expect(son.prototyped_methods.length).to eq(0)

    #verificamos que el metamodel hijo hereda los metodos del padre
    expect(son.get_method('a_method').block).to eq(block)
  end


end