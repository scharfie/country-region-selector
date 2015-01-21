require 'carmen'
require 'json'

data = Carmen::Country.all.map do |country|
  regions = country.subregions.map do |region|
    [region.name, region.code]
  end
  
  [country.name, country.code, regions]
end

puts JSON.generate(:data => data)
