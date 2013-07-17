# encoding: UTF-8
module LatLon
  class Service
    attr_reader :shapefile

    def initialize shp_file
      @shapefile = shp_file
      print "Setting up #{shp_file} with "
      @factory = ::RGeo::Cartesian.preferred_factory()
      @records = []
      RGeo::Shapefile::Reader.open(shp_file) do |file|
        puts "#{file.num_records} records."
        file.each do |record|
          print '.'; $stdout.flush
          @records << record
        end
      end
      puts "done.... GO!"
    end

    def latlon2info lat, lon
      point = @factory.point lat, lon

      @records.each do |record|
        if record.geometry.contains? point
          return record
        end
      end
      raise NoRecordFound
    end

  end
  class NoRecordFound < Exception ; end
end
