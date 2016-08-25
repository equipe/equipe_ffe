class Equipe::HorseName

  def initialize(name)
    @name = name
  end

  def normalize
    converted = name.to_s.mb_chars.titleize.to_s
    converted.gsub!(/\b[a-z]{,2}$/i) { |s| s.upcase }
    converted.gsub!(/\bsfn$/i) { |s| s.upcase }
    converted.gsub!(/\bvdl\b/i) { |s| s.upcase }
    converted.gsub!(/\b's\b/i) { |s| s.downcase }
    converted.gsub!(/\b(vh|af|de|des|du|van den?|van het|of the)\b/i) { |s| s.downcase }
    converted.gsub!(/\b\(?[LIVX]+\)?\b/i) { |s| s.upcase }
    converted.gsub!(/\b(D|L)'\b/) { |s| s.downcase }
    converted.gsub!(/\bswb\b/i) { |s| s.upcase }
    converted.to_s
  end

  private

  attr_reader :name
end