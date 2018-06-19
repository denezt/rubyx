require_relative "../helper"

module Risc
  class InterpretSetByte < MiniTest::Test
    include Ticker

    def setup
      @string_input = as_main("return 'Hello'.set_internal_byte(0,75)")
      super
    end

    def test_chain
      #show_main_ticks # get output of what is
      check_main_chain [LoadConstant, LoadConstant, SlotToReg, RegToSlot, RegToSlot,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             RegToSlot, SlotToReg, RegToSlot, Branch, SlotToReg,
             RegToSlot, LoadConstant, SlotToReg, RegToSlot, LoadConstant,
             SlotToReg, SlotToReg, RegToSlot, LoadConstant, SlotToReg,
             SlotToReg, RegToSlot, Branch, LoadConstant, SlotToReg,
             RegToSlot, SlotToReg, FunctionCall, SlotToReg, SlotToReg,
             SlotToReg, SlotToReg, SlotToReg, SlotToReg, SlotToReg,
             RegToByte, SlotToReg, SlotToReg, RegToSlot, SlotToReg,
             SlotToReg, Branch, RegToSlot, SlotToReg, SlotToReg,
             SlotToReg, FunctionReturn, SlotToReg, SlotToReg, RegToSlot,
             SlotToReg, SlotToReg, RegToSlot, SlotToReg, SlotToReg,
             Branch, RegToSlot, SlotToReg, SlotToReg, SlotToReg,
             FunctionReturn, Transfer, SlotToReg, Branch, SlotToReg,
             Syscall, NilClass]
       assert_equal "K".ord , get_return
    end
    def test_reg_to_byte
      done = main_ticks(41)
      assert_equal RegToByte ,  done.class
      assert_equal "K".ord ,  @interpreter.get_register(done.register)
    end
    def test_exit
      done = main_ticks(71)
      assert_equal Syscall ,  done.class
    end

  end
end
