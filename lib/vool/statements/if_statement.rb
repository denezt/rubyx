require_relative "hoister"
module Vool
  class IfStatement < Statement
    include Hoister
    
    attr_reader :condition , :if_true , :if_false

    def initialize( cond , if_true , if_false = nil)
      @condition = cond
      @if_true = if_true
      @if_false = if_false
      simplify_condition
    end

    def to_mom( method )
      if_true =   @if_true.to_mom( method )
      if_false =  @if_false.to_mom( method )
      condition , hoisted  = hoist_condition( method )
      cond = Mom::TruthCheck.new(condition.to_mom(method))
      check = Mom::IfStatement.new(  cond , if_true , if_false )
      check.hoisted = hoisted.to_mom(method) if hoisted
      check
    end


    def collect(arr)
      @if_true.collect(arr)
      @if_false.collect(arr)
      super
    end

    def simplify_condition
      return unless @condition.is_a?(ScopeStatement)
      @condition = @condition.first if @condition.single?
    end

    def has_false?
      @if_false != nil
    end

    def has_true?
      @if_true != nil
    end

  end
end
