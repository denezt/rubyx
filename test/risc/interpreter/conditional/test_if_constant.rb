require_relative "../helper"

module Risc
  class InterpreterIfConstant < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main 'if( 10 ); return "then";else;return "else";end'
      super
    end

    def test_if
        #show_main_ticks # get output of what is in main
        check_main_chain [LoadConstant, LoadConstant, OperatorInstruction, IsZero, LoadConstant,
             OperatorInstruction, IsZero, LoadConstant, RegToSlot, SlotToReg,
             SlotToReg, RegToSlot, SlotToReg, SlotToReg, FunctionReturn,
             Transfer, Syscall, NilClass]
      assert_equal Parfait::Word , get_return.class
      assert_equal "then" , get_return.to_string
    end
    def test_load_10
      load = main_ticks(1)
      assert_equal LoadConstant , load.class
      assert_equal 10 , load.constant.value
    end
    def test_load_false
      load = main_ticks(2)
      assert_equal LoadConstant , load.class
      assert_equal Parfait::FalseClass , load.constant.class
    end
    def test_compare
      op = main_ticks(3)
      assert_equal OperatorInstruction , op.class
      assert_equal :- , op.operator
    end
    def test_not_zero
      check = main_ticks(4)
      assert_equal IsZero , check.class
      assert check.label.name.start_with?("false_label") , check.label.name
    end
    def test_exit
      done = main_ticks(17)
      assert_equal Syscall ,  done.class
    end
  end
end
