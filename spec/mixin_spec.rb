require 'spec_helper'

class Component
  def method_alpha
    'alpha'
  end

  def method_beta(value)
    value
  end

  def operation
    :result
  end
end

describe 'Mixin' do
  let(:component) { Component.new }
  let(:decorated_component) { ConcreteDecorator.new(component) }

    it 'implements the component interface' do
      class Component
        def my_method
        end
      end
      class DecoratedComponent
        include Decoration
      end
      component = Component.new
      decorated_component = DecoratedComponent.new(component)
      expect(decorated_component.public_methods(false)).to include(*component.public_methods(false))
    end

  it 'have the same signature as in component' do
    value = 'beta'

    expect(component).to receive(:method_beta).
      with(value).and_call_original

    decorated_component.method_beta(value)
  end

  it 'fails on component method collisions' do
    expect { NotJustAnotherConcreteDecorator.new(decorated_component) }.
      to raise_error('method method_alpha collides with the same name method of the component decorated')
  end

  it 'supports absence of behaviors' do
    class WithoutBehaviours
      include Decoration
    end
    without_behaviours = WithoutBehaviours.new(component)

    expect { without_behaviours.method_alpha }.not_to raise_error
  end
end

class ConcreteDecorator
  include Decoration

  add_behaviors method_alpha: :behavior,
    method_beta: :other_behavior

  private

  def behavior(original)
    original + ' decorated'
  end

  def other_behavior(original, value)
    if value == 'beta'
      'decorated ' + original
    else
      'not decorated beta'
    end
  end
end

class AnotherConcreteDecorator
  include Decoration

  add_behaviors method_alpha: :another_behavior

  private

  def another_behavior(original)
    original + ' another'
  end
end

class NotJustAnotherConcreteDecorator
  include Decoration

  add_behaviors method_alpha: :method_alpha

  private

  def method_alpha(original)
    original + ' another'
  end
end
