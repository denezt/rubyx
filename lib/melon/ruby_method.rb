module Melon

  class RubyMethod

    attr_reader :name , :args_type , :locals_type , :source

    def initialize(name , args_type , locals_type , source )
      @name , @args_type , @locals_type , @source = name , args_type, locals_type , source
    end

    def normalize_source
      @source = yield @source
    end
  end
end
