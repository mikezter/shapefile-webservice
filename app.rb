# encoding: UTF-8
Bundler.require
require './lib'


also_reload './lib.rb'
set :haml, format: :html5

SHAPE_FILE_DIR = "#{File.dirname(File.expand_path(__FILE__))}/data/shapefiles/"
$lat_lon_service = nil
$lat_lon_services = {}

def current_shapefile
  File.basename($lat_lon_service && $lat_lon_service.shapefile || '', '.shp')
end

get '/' do
  @shape_files = Dir["#{SHAPE_FILE_DIR}/*.shp"].collect{ |f| File.basename(f, '.shp') }
  @current = File.basename(current_shapefile, '.shp')
  haml :index
end

get '/vectormap' do
  haml :vectormap
end

post '/select' do
  name = params[:shapefile]
  file = "#{SHAPE_FILE_DIR}#{name}.shp"
  $lat_lon_service = $lat_lon_services[name] ||= LatLon::Service.new(file)
  redirect '/'
end

get '/lonlat2info/:lat/:lon' do
  return {error: "No shapefile selected"}.to_json unless $lat_lon_service
  begin
    results = $lat_lon_service.latlon2info params[:lon].to_f, params[:lat].to_f
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

