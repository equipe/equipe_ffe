require 'test_helper'

class Equipe::EntriesTest < ActiveSupport::TestCase

  test "returns equipe compatible json structure" do
    parser = EntryFile.new(Rails.root.join('test', 'fixtures', 'files', 'conc1694854.xml').read)
    parser.import
    output = Equipe::Entries.new(parser.show).to_json
    # pp Oj.load(output)
  end

end