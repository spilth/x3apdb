NAMESFILE = "data/names.properties"
RACESFILE = "data/races.xml"
SECTORSFILE = "data/sectors.xml"

namespace :import do
  desc "Import All Data"
  task :all => :environment do
    names = {}
    ids = {}
    puts "Importing races..."
    File.open(NAMESFILE) do |name_file|
      name_file.read.each_line do |line|
        line.strip!
        if !line.start_with?("#") 
          i = line.index('=')
          j = line.index('.')
          if i and j
            group = line[0..j-1].strip
            key = line[j+1..i-1].strip
            value = line[i+1..-1].strip
            #puts "#{group},#{key},#{value}"
            names[group] ||= {}
            ids[group] ||= {}
            names[group][key] = value
            #puts names
          end
        end
      end
    end

    f = File.open(RACESFILE)
    doc = Nokogiri::XML(f)
    f.close

    # Create Races
    races = doc.xpath("//race")
    races.each do |element|
      name = element['id']
      proper_name = names["race"][name]
      race = Race.find_or_create_by_name(proper_name)
      ids["race"][name] = race.id
    end
    
    f = File.open(SECTORSFILE)
    doc = Nokogiri::XML(f)
    f.close

    # Create Sectors
    sectors = doc.xpath("//sector")
    sectors.each do |element|
      name = element['id']
      race = element['race']
      proper_name = names["sector"][name]
      sector = Sector.find_or_create_by_name_and_race_id(proper_name, ids["race"][race])
      ids["sector"][name] = sector.id
    end

    # Link Sectors
    sectors.each do |element|
      name = element['id']
      proper_name = names["sector"][name]
      sector = Sector.find_by_name(proper_name)
      north = element['north']
      south = element['south']
      east = element['east']
      west = element['west']
      sector.update_column("north_sector_id", ids["sector"][north]) if north
      sector.update_column("south_sector_id", ids["sector"][south]) if south
      sector.update_column("east_sector_id", ids["sector"][east]) if east
      sector.update_column("west_sector_id", ids["sector"][west]) if west
    end
  end
end

