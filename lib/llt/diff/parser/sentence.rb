module LLT
  class Diff::Parser
    class Sentence
      include HashContainable

      container_alias :words

      def initialize(id)
        super
        @comparable_elements = %i{ lemma postag head relation }
      end

      def report
        @report ||= create_report
      end

      def compare(other)
        diff = SentenceDiff.new(self)
        words.each do |id, word|
          other_word = other[id]
          @comparable_elements.each do |comparator|
            a, b = [word, other_word].map { |w| w.send(comparator).to_s }
            if a != b
              d = diff[id] ||= WordDiff.new(id)
              d.send("#{comparator}=", [a, b])
            end
          end
        end

        diff
      end

      private

      def create_report
        @report ||= begin
          report_container.each do |_, reportable|
            if rtr = reportable.reports_to_request
              words.each { |_, word| reportable.add(word.send(rtr).report) }
            end
          end
        end
      end

      def report_container
        reports = {
          words: nil,
          heads: nil,
          relations: :relation,
          lemmata: :lemma,
          postags: :postag,
        }

        reports.each_with_object({}) do |(tag, requested), hsh|
          hsh[tag] = Report::Generic.new(tag, size, requested)
        end
      end
    end
  end
end

