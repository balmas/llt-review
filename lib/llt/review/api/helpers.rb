module LLT
  module Review::Api
    module Helpers
      def origin(el)
        "Publication ##{extracted_id(el.id)} by #{el.sentences.annotators}"
      end

      def extracted_id(id)
        last = id.split('/').last
        /(.*?)(\.([\d\w]*?))?$/.match(last)[1]
      end

      def arethusa(rev, gold = nil, chunk = nil, word = nil)
        #"http://sosol.perseids.org/tools/arethusa/app/#/perseidslataldt?doc=#{rev}"
        "http://85.127.253.84:8081/app/#/review_test?doc=#{rev}&gold=#{gold}"
      end

      def to_tooltip(cat, v)
        %{#{cat}: <span class="success">#{v.original}</span> -> <span class="error">#{v.new}</span>}
      end

      def extract_heads(diff, s_id)
        if heads = diff[:head]
          [to_id(s_id, heads.original), to_id(s_id, heads.new)]
        end
      end

      def to_id(s_id, w_id)
        "#{s_id}-#{w_id}"
      end

      def to_percent(total, part)
        ((part.to_f / total) * 100).round(2)
      end
    end
  end
end
