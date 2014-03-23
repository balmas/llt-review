module LLT
  class Diff
    class Parser
      require 'llt/diff/parser/hash_containable'
      require 'llt/diff/parser/reportable'
      require 'llt/diff/parser/no_unique_reportable'
      require 'llt/diff/parser/diff_reporter'

      require 'llt/diff/parser/report'
      require 'llt/diff/parser/gold'
      require 'llt/diff/parser/reviewable'
      require 'llt/diff/parser/comparison'
      require 'llt/diff/parser/parse_result'

      require 'llt/diff/parser/sentence'
      require 'llt/diff/parser/word'
      require 'llt/diff/parser/postag'

      require 'llt/diff/parser/difference'

      require 'llt/diff/parser/parse_helper'
      autoload :NokogiriHandler, 'llt/diff/parser/nokogiri_handler'
      autoload :OxHandler,       'llt/diff/parser/ox_handler'

      def parse(data)
        io = StringIO.new(data)
        handler.parse(io)
        io.close
        handler.result
      end

      def handler
        @handler ||= begin
          if RUBY_PLATFORM == 'java'
            NokogiriHandler.new
          else
            OxHandler.new
          end
        end
      end
    end
  end
end


