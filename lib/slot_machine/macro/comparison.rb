module SlotMachine
  class Comparison < Macro

    def self.operators
      [:<, :>, :>=, :<=]
    end

    attr_reader :operator

    def initialize(name , operator)
      super(name)
      raise "unsuported operator :#{operator}:#{operator.class}:" unless self.class.operators.include?(operator)
      @operator = operator
    end

    # basically use subtract to subtract left from right (or right from left)
    # and load true_object in the true branch and false_object in the false
    # for the case of =, as in <= or >= we also do not check for zero
    def to_risc(compiler)
      builder = compiler.builder(compiler.source)
      operator = @operator # make accessible in block
      false_label = Risc.label("false" , "false_label_#{object_id}")
      merge_label = Risc.label("merge" , "merge_label_#{object_id}")
      result = Risc::RegisterValue.new(:result , :Object)
      builder.build do
        left = message[:receiver].reduce_int(false) #false == hack
        right = message[:arg1].reduce_int(false)

        if(operator.to_s.start_with?('<') )
          right.op :- , left
        else
          left.op :- , right
        end
        if_minus false_label
        if_zero( false_label ) if operator.to_s.length == 1
        add_code Risc::LoadConstant.new(to_s , Parfait.object_space.true_object, result)
        branch merge_label
        add_code false_label
        add_code Risc::LoadConstant.new(to_s , Parfait.object_space.false_object, result)
        add_code merge_label
        message[:return_value] << result
      end
      return compiler
    end
  end
end
