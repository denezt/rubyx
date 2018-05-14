module Risc
  module Builtin
    module Word
      module ClassMethods
        include CompileHelper

        def putstring( context)
          compiler = compiler_for(:Word , :putstring ,{})
          builder = compiler.builder(true, compiler.method)
          builder.add_slot_to_reg( "putstring" , :message , :receiver , :new_message )
          index = Parfait::Word.get_length_index
          reg = RiscValue.new(:r2 , :Integer)
          builder.add_slot_to_reg( "putstring" , :new_message , index , reg )
          Risc::Builtin::Object.emit_syscall( builder , :putstring )
          compiler.add_mom( Mom::ReturnSequence.new)
          compiler.method
        end

        # self[index] basically. Index is the first arg > 0
        # return (and word sized int) is stored in return_value
        def get_internal_byte( context)
          compiler = compiler_for(:Word , :get_internal_byte , {at: :Integer})
          source = "get_internal_byte"
          builder = compiler.builder(true, compiler.method)
          me , index = builder.self_and_int_arg(source)
          builder.reduce_int( source + " fix arg", index )
          # reduce me to me[index]
          builder.add_byte_to_reg( source , me , index , me)
          builder.add_new_int(source, me , index)
          # and put it back into the return value
          builder.add_reg_to_slot( source , index , :message , :return_value)
          compiler.add_mom( Mom::ReturnSequence.new)
          return compiler.method
        end

        # self[index] = val basically. Index is the first arg ( >0),
        # value the second
        # return self
        def set_internal_byte( context )
          compiler = compiler_for(:Word, :set_internal_byte , {at: :Integer , :value => :Integer} )
          source = "set_internal_byte"
          builder = compiler.builder(true, compiler.method)
          me , index = builder.self_and_int_arg(source)
          value = builder.load_int_arg_at(source , 1 )
          builder.reduce_int( source + " fix me", value )
          builder.reduce_int( source + " fix arg", index )
          builder.add_reg_to_byte( source , value , me , index)
          builder.add_reg_to_slot( source , me , :message , :return_value)
          compiler.add_mom( Mom::ReturnSequence.new)
          return compiler.method
        end

      end
      extend ClassMethods
    end
  end
end
