module LLT
  class Diff::Parser
    class Word
      include HashContainable

      attr_accessor :form, :lemma, :head, :relation
      attr_reader :postag

      Attr = Struct.new(:id, :attribute) do
        def to_s
          attribute
        end

        def report
          @report ||= Report.const_get(id.capitalize).new(attribute)
        end
      end

      %i{ lemma head relation }.each do |type|
        define_method("#{type}=") { |val| add(Attr.new(type, val)) }
      end

      def postag=(tag)
        add(Postag.new(tag))
      end

      def method_missing(meth, *args, &blk)
        super unless meth =~ /=$/
      end
    end
  end
end
