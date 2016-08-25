class Equipe::Entries

  def initialize(show)
    @show = show
  end

  def as_json(*)
    {
      show: {
        id: show.id,
        name: show.name,
        starts_on: show.starts_on,
        ends_on: show.ends_on,
        currency: 'EUR',
        foreign_tax_skip: 'FRA'
      },
      competitions: competitions,
      people: people,
      clubs: clubs,
      horses: horses,
      entries: entries
    }
  end

  private

  attr_reader :show

  def competitions
    show.competitions.select(:id, :competition_no, :name, :starts_on, :discipline, :judgement_id, 'true AS randomized', "'H'::text AS horse_pony", "'R'::text AS status")
  end

  def people
    show.people.select(:id, :first_name, :last_name, :licence, 'birthday AS person_no', "'FRA'::text AS country", :official, :club_id)
  end

  def clubs
    show.clubs.select(:id, :name, 'clubs.ffe_id AS logo_id', "'ffe'::text AS logo_group")
  end

  def horses
    show.horses.select(:id, :licence, :name, :sire, :dam, :dam_sire, :born_year, :color, :breed, :race, :height, :sex, "'H'::text AS category")
  end

  def entries
    # Start no and position should only be given when the start list is already randomized
    show.entries.joins(:competition).select(:id, 'competitions.competition_no AS competition_no', :start_no, 'start_no AS position', :rider_id, :horse_id, 'rider_id AS payer_id')
  end
end