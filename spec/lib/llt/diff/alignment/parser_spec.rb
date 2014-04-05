require 'spec_helper'

describe LLT::Diff::Alignment::Parser do
  let(:parser) { LLT::Diff::Alignment::Parser.new }

  # Orgetorix rex fuit. => Orgetorix was a king. - Actually, he wasn't.
  let(:data) { <<-EOF }
    <aligned-text xmlns="http://alpheios.net/namespaces/aligned-text">
      <language lnum="L1" xml:lang="lat"/>
      <language lnum="L2" xml:lang="eng"/>
      <sentence id="1">
          <wds lnum="L1">
              <w n="1-1">
                  <text>Orgetorix</text>
                  <refs nrefs="1-1"/>
              </w>
              <w n="1-2">
                  <text>rex</text>
                  <refs nrefs="1-3 1-4"/>
              </w>
              <w n="1-3">
                  <text>fuit</text>
                  <refs nrefs="1-2"/>
              </w>
              <w n="1-4">
                  <text>.</text>
                  <refs nrefs="1-5"/>
              </w>
          </wds>
          <wds lnum="L2">
              <w n="1-1">
                  <text>Orgetorix</text>
                  <refs nrefs="1-1"/>
              </w>
              <w n="1-2">
                  <text>was</text>
                  <refs nrefs="1-3"/>
              </w>
              <w n="1-3">
                  <text>a</text>
                  <refs nrefs="1-2"/>
              </w>
              <w n="1-4">
                  <text>king</text>
                  <refs nrefs="1-2"/>
              </w>
              <w n="1-5">
                  <text>.</text>
                  <refs nrefs="1-4"/>
              </w>
          </wds>
      </sentence>
    </aligned-text>
  EOF

  describe "#parse" do
    it "returns parsed sentences" do
      result = parser.parse(data)
      s1= result[1]
      s1.should be_true
      s1.lang1.should == 'lat'
      s1.lang2.should == 'eng'
      s1.should have(4).items
      rex = s1[2]
      rex.should have(2).items
      rex.translation.should == 'a king'
      rex[3].to_s.should == 'a'
      rex[4].to_s.should == 'king'
    end
  end
end

