module Decoration
  def self.included(base)
    base.extend(ClassMethods)
  end

  module ClassMethods
    def add_behaviors(behaviors)
      @behaviors = behaviors
    end

    attr_reader :behaviors
  end

  def initialize(component)
    @component = component
    check_behaviors!
    define_delegation
  end

  private

  def check_behaviors!
    get_decorations.each do |behavior|
      raise "method #{behavior} collides with the same name method of the component decorated" if get_originals.include?(behavior)
    end
  end

  def get_decorations
    get_behaviors.map { |_, value| value }
  end

  def define_delegation
    get_originals.each do |method|
      define_delegated_method(method)
    end
  end

  def define_delegated_method(operation)
    self.class.send(:define_method, operation) do |*args|
      result = execute_original(operation, args)
      decorate(result, behavior_for(operation), args)
    end
  end

  def decorate(original_result, method, args)
    return original_result unless method

    send(method, original_result, *args)
  end

  def execute_original(operation, args)
    @component.send(operation, *args)
  end

  def behavior_for(operation)
    get_behaviors[operation]
  end

  def get_originals
    @component.public_methods(false)
  end

  def get_behaviors
    self.class.behaviors || {}
  end
end
