require 'llt/core/api/helpers'
require "llt/diff/version"

module LLT
  class Diff
    require 'llt/diff/common'
    require 'llt/diff/helpers'
    require 'llt/diff/treebank'
    require 'llt/diff/alignment'

    include Core::Api::Helpers

    def diff(gold, reviewables)
      parses = parse_files(Gold: gold, Reviewable: reviewables)

      @gold, @reviewables = parses.partition do |parse_data|
        parse_data.instance_of?(self.class.const_get(:Gold))
      end

      compare
      diff_report
      all_diffs
    end

    def report(*uris)
      @reports = parse_files(Report: uris)
      @reports.each(&:report)
      @reports
    end

    def to_xml(type = :diff)
      root_name = "#{root_identifier}-#{type}"
      XML_DECLARATION + wrap_with_tag(root_name, header + send("#{type}_to_xml"))
    end

    private

    def all_diffs
      @all_diffs ||= @reviewables.map do |reviewable|
        reviewable.diff.values
      end.flatten
    end

    def diff_report
      if @reviewables.one?
        all_diffs.each(&:report)
      else
        diff_report_with_cloned_reports
      end
    end

    # Check the comment at Comparison#report for more info
    def diff_report_with_cloned_reports
      used_golds = []
      all_diffs.each do |d|
        d.report(to_clone_or_not_to_clone?(used_golds, d.gold.id))
      end
    end

    def to_clone_or_not_to_clone?(used, id)
      used.include?(id) ? true : (used << id; false)
    end

    def compare
      @gold.each do |gold|
        @reviewables.each { |reviewable| reviewable.compare(gold) }
      end
    end

    def parse_files(files)
      to_parse = files.flat_map { |klass, uris| uris.map { |uri| [klass, uri] } }
      parse_threaded(to_parse)
    end

    def parse_threaded(uris_with_classes)
      threads = uris_with_classes.map do |klass, uri|
        Thread.new do
          data = get_from_uri(uri)
          self.class.const_get(klass).new(uri, parse(data))
        end
      end
      threads.map { |t| t.join; t.value }
    end

    def header
      wrap_with_tag('files', header_files.map(&:xml_heading).join)
    end

    def header_files
      [@gold, @reviewables, @reports].flatten.compact
    end

    def wrap_with_tag(tag, content)
      "<#{tag}>" +
        content +
      "</#{tag}>"
    end

    def diff_to_xml
      @reviewables.map(&:to_xml).join
    end

    def report_to_xml
      @reports.map(&:to_xml).join
    end

    def parse(data)
      self.class.const_get(:Parser).new.parse(data)
    end
  end
end
