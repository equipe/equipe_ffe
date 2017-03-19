require 'test_helper'

class EntryFileTest < ActiveSupport::TestCase

  test "imports show jumping entries" do
    parser = EntryFile.new(Rails.root.join('test', 'fixtures', 'files', 'conc1694854.xml').read)

    parser.import

    entry = Entry.find_by(ffe_id: '169485405 00001')

    assert_equal 20, entry.start_no
    assert_equal "05", entry.competition.competition_no
    assert_equal "Poney 4 Grand Prix", entry.competition.name
    assert_equal "H", entry.competition.discipline

    assert_equal "Unititled", entry.rider.first_name
    assert_equal "Unititled", entry.rider.last_name
    assert_equal "22", entry.rider.region.ffe_id
    assert_equal "RHONE ALPES", entry.rider.region.name
    assert_equal "SPORTS EQU DE BELLE FERME", entry.rider.club.name

    assert_equal "Unititled", entry.horse.name
    assert_equal 141, entry.horse.height
    assert_equal "PONEY FRANCAIS DE SELLE", entry.horse.race
    assert_equal "PFS", entry.horse.breed
    assert_equal "ALEZAN", entry.horse.color
    assert_equal 2001, entry.horse.born_year
    assert_equal "250259600183712", entry.horse.chip_no
    assert_equal "G", entry.horse.sex
    assert_equal "Sire", entry.horse.sire
    assert_equal "Dam", entry.horse.dam
    assert_equal "DamSire", entry.horse.dam_sire
  end

  test "imports dressage entries" do
    parser = EntryFile.new(Rails.root.join('test', 'fixtures', 'files', 'conc1694861.xml').read)

    parser.import

    entry = Entry.find_by(ffe_id: '169486106 00001')

    assert_equal 1, entry.start_no
    assert_equal "06", entry.competition.competition_no
    assert_equal "Poney 1 Grand Prix", entry.competition.name
    assert_equal "D", entry.competition.discipline

    assert_equal "Unititled", entry.rider.first_name
    assert_equal "Unititled", entry.rider.last_name
    assert_equal "22", entry.rider.region.ffe_id
    assert_equal "RHONE ALPES", entry.rider.region.name
    assert_equal "SPORTS EQU DE BELLE FERME", entry.rider.club.name

    assert_equal "Unititled", entry.horse.name
    assert_equal 148, entry.horse.height
    assert_equal "DEUTSCHES REITPONY", entry.horse.race
    assert_equal "DRPON", entry.horse.breed
    assert_equal "ALEZAN", entry.horse.color
    assert_equal 1994, entry.horse.born_year
    assert_equal "756095200047042", entry.horse.chip_no
    assert_equal "S", entry.horse.sex
    assert_equal "Unititled", entry.horse.sire
    assert_equal "Unititled", entry.horse.dam
    assert_equal "Unititled", entry.horse.dam_sire
  end

  test "invalid content" do
    parser = EntryFile.new("<invalid></invalid>")
    assert_not parser.valid?

    parser = EntryFile.new(nil)
    assert_not parser.valid?
  end

end
