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
    show.competitions.select(:id, :competition_no, :name, :starts_on, :discipline, :horse_pony, :judgement_id, :late_entry_fee, 'true AS randomized', "'N'::text AS status", "'all_categories_together'::text AS category_merge").map do |competition|
      attrs = competition.attributes
      attrs['id'] = attrs['id'].to_s
      attrs
    end
  end

  def people
    show.people.select(:id, :first_name, :last_name, :licence, 'birthday AS person_no', "'FRA'::text AS country", :official, :club_id).map do |person|
      attrs = person.attributes
      attrs['id'] = attrs['id'].to_s
      attrs['club_id'] = attrs['club_id'].to_s
      attrs
    end
  end

  def clubs
    show.clubs.select(:id, :name, 'clubs.ffe_id AS logo_id', "'ffe'::text AS logo_group").map do |club|
      attrs = club.attributes
      attrs['id'] = attrs['id'].to_s
      attrs
    end
  end

  def horses
    show.horses.select(:id, :licence, :name, :sire, :dam, :dam_sire, :born_year, :color, :breed, :race, :height, :sex, :category).map do |horse|
      attrs = horse.attributes
      attrs['id'] = attrs['id'].to_s
      attrs
    end
  end

  def entries
    # Start no and position should only be given when the start list is already randomized
    show.entries.joins(:competition).select(:id, 'competitions.competition_no AS competition_no', :start_no, 'start_no AS position', :rider_id, :horse_id, 'rider_id AS payer_id').map do |entry|
      attrs = horse.attributes
      attrs['id'] = attrs['id'].to_s
      attrs['rider_id'] = attrs['rider_id'].to_s
      attrs['horse_id'] = attrs['horse_id'].to_s
      attrs['payer_id'] = attrs['payer_id'].to_s
      attrs
    end
  end
end
