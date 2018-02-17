require "set"

require "ruby_parser"
require "sexp_processor"

module Deathnote
  class MethodProcessor < MethodBasedSexpProcessor
    attr_reader :known

    def initialize
      super
      @known = {}
    end

    def run(file_paths)
      file_paths.each do |file_path|
        exp = \
          begin
            file = File.binread(file_path)

            rp = RubyParser.for_current_ruby rescue RubyParser.new
            rp.process(file, file_path)
          rescue Racc::ParseError, RegexpError => e
            warn "Parse Error parsing #{file_path}. Skipping."
            warn "  #{e.message}"
          end
        process(exp)
      end
      @known
    end

    SINGLETON_METHOD_DELIMITER = /^::/
    def recognize(target_klass_name, method_name)
      if @known[target_klass_name].nil?
        @known[target_klass_name] = Set.new
      end

      fixed_method_name = method_name.sub(SINGLETON_METHOD_DELIMITER, ".")

      if @known[target_klass_name].member?(fixed_method_name)
        warn "Ignore '#{target_klass_name}#{fixed_method_name}' is already known. It seems to be declared more than once."
      else
        @known[target_klass_name].add(fixed_method_name)
      end
    end

    def klass_name
      super.to_s
    end

    def process_defn(sexp)
      super do
        recognize(klass_name, method_name)
        process_until_empty(sexp)
      end
    end

    def process_defs(sexp)
      super do
        recognize(klass_name, method_name)
        process_until_empty(sexp)
      end
    end
  end
end
