Bundler.require

class Converter
  attr_reader :shapefile

  def initialize(shapefile)
    @shapefile = shapefile
  end

  def outfile
    "#{shape_name}.js"
  end

  def convert
    RGeo::Shapefile::Reader.open(shapefile) do |file|
      file.each do |record|

        require 'pry';binding.pry
      end
    end
  end

  def write
  end
  private

  def shape_name
    File.basename(shapefile, '.shp')
  end

end

if $0 == __FILE__
  SHAPE_FILE_DIR = "#{File.dirname(File.expand_path(__FILE__))}/data/shapefiles"
  c = Converter.new("#{SHAPE_FILE_DIR}/PLZ_2_Leitregion_2013_region.shp")
  c.convert
end

