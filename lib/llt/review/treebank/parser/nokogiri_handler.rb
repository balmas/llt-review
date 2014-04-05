require 'nokogiri'

module LLT
  class Review::Treebank::Parser
    class NokogiriHandler < Nokogiri::XML::SAX::Document

      include Review::Helpers::Parsing::Helper
      include Review::Helpers::Parsing::Helper::ForNokogiri
      include Helper

      def parse(data)
        Nokogiri::XML::SAX::Parser.new(self).parse(data)
      end

      def start_element(name, attrs = [])
        case name
        when 'word'     then register_word(attrs)
        when 'sentence' then register_sentence(first_val(attrs))
        end
      end

      private

      def register_word(attrs)
        super(attrs.shift.last) # need to shift, we don't want the id in the next step
        attrs.each { |k, v| @word.send("#{k}=", v) }
      end
    end
  end
end
