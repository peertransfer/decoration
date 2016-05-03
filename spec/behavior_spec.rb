require 'spec_helper'

describe 'Behavior' do
  it 'delegate all calls to the component' do
    class Component
      def method_alpha
        'alpha'
      end
    end
    class Log
      include Decoration
    end
    component = Component.new
    decorated = Log.new(component)
    expect(component).to receive(:operation)

    decorated.operation
  end

  it 'adds behavior to the component' do
    class Journey
      def distance
        10
      end
    end
    class KmsFormatter
      include Decoration

      add_behaviors distance: :with_symbol

      private

      def with_symbol(original)
        "#{original} kms"
      end
    end
    component = Journey.new
    decorated = KmsFormatter.new(component)
    original_result = component.distance

    expect(decorated.distance).to eq("10 kms")
  end

  it 'is stackable' do
    class Chips
      def amount
        1_200
      end
    end
    class ThousandFormatter
      include Decoration

      add_behaviors amount: :amount_with_format

      private

      def amount_with_format(original)
        original.to_s.reverse.gsub(/...(?=.)/,'\&.').reverse
      end
    end
    class HumanTranslator
      include Decoration

      add_behaviors amount: :translated_amount

      def translated_amount(original)
        "#{original} Chips"
      end
    end
    component = Chips.new
    decorated_component = ThousandFormatter.new(component)
    stacked_component = HumanTranslator.new(decorated_component)

    expect(stacked_component.amount).to eq(
      '1.200 Chips'
    )
  end
end
