# encoding: UTF-8
Bundler.require
require './lib'


also_reload './lib.rb'
set :haml, :format => :html5
SHAPE_FILE_DIR = './data/shapefiles/'
SHAPE_FILE = SHAPE_FILE_DIR + 'PLZ_2_Leitregion_2013_region.shp'
#LATLON_SERVICE = LatLon::Service.new(SHAPE_FILE)

get '/' do
  @shape_files = Dir["#{SHAPE_FILE_DIR}/*.shp"].collect{ |f| File.basename(f, '.shp') }
  haml :index
end

get '/app.js' do
  coffee :app
end

get '/lonlat2info/:lat/:lon' do
  begin
    results = LATLON_SERVICE.latlon2info params[:lon].to_f, params[:lat].to_f
    results.attributes.each_pair do |key,val|
      results.attributes[key] = val.force_encoding('iso-8859-1').encode('utf-8') if val.is_a?(String)
    end
    convert_to_json results
  rescue LatLon::NoRecordFound
    {error: 'No Record found for that location'}.to_json
  end
end

def convert_to_json result
  begin result.attributes.to_json rescue {error: "Something went wrong with encoding... :)"}.to_json end
end

