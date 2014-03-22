module LLT
  class Diff::Parser
    class PostagDiff < GenericDiff
      def initialize(tag, original, new)
        super
        compute_detailed_differences
      end

      def diff_id
        @diff_id ||= "#{id}:#{map { |_, v| v.diff_id }.join('::')}"
      end

      private

      # copied over right now from Postag until we figure out how to solve this
      # more globally

      POSTAG_SCHEMA = %i{
        part_of_speech person number tense
        mood voice gender case degree
      }

      Temp = Struct.new(:id)
      def compute_detailed_differences
        @original.each_char.with_index do |a, i|
          b = @new[i]
          add(GenericDiff.new(Temp.new(POSTAG_SCHEMA[i]), a, b)) unless a == b
        end
      end
    end
  end
end
