require_relative "virtual_helper"

class TestBasic < MiniTest::Test
  include VirtualHelper

  def test_number
    @string_input    = '42 '
    @output = [Virtual::IntegerConstant.new(42)]
    check
  end

  def test_true
    @string_input    = 'true '
    @output = [Virtual::TrueValue.new()]
    check
  end
  def test_false
    @string_input    = 'false '
    @output = [Virtual::FalseValue.new()]
    check
  end
  def test_nil
    @string_input    = 'nil '
    @output = [Virtual::NilValue.new()]
    check
  end

  def test_name
    @string_input    = 'foo '
    @output = [Virtual::FrameSend.new(:foo)]
    check
  end

  def test_self
    @string_input    = 'self '
    @output = [Virtual::SelfReference.new()]
    check
  end

  def test_instance_variable
    @string_input    = '@foo_bar '
    @output = [Virtual::FrameSend.new(:_get_instance_variable , [ Virtual::StringConstant.new('foo_bar')])]
    check
  end

  def test_module_name
    @string_input    = 'FooBar '
    @output = [Boot::BootClass.new(:FooBar,:Object)]
    check
  end

  def test_string
    @string_input    = "\"hello\""
    @output =  [Virtual::StringConstant.new('hello')]
    check
  end

end