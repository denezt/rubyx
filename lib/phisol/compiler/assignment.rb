module Phisol
  Compiler.class_eval do

    def on_assignment statement
      reset_regs # statements reset registers, ie have all at their disposal
      puts statement.inspect
      name , value = *statement
      name = name.to_a.first
      v = process(value)
      raise "Not register #{v}" unless v.is_a?(Register::RegisterValue)
      code = nil
      if( index = @method.has_arg(name))
         # TODO, check type @method.arguments[index].type
        code = Register.set_slot(statement , v , :message , index )
      else # or a local so it is in the frame
        index = @method.has_local( name )
        if(index)
          # TODO, check type  @method.locals[index].type
          code = Register.set_slot(statement , v , :frame , index )
        end
      end
      if( code )
        puts "addin code #{code}"
        @method.source.add_code code
      else
        raise "must define variable #{name} before using it in #{@method.inspect}"
      end
    end

  end
end
