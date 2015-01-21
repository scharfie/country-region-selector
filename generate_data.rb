require 'carmen'
require 'json'
require 'erb'

format = ARGV.shift || "json"

data = Carmen::Country.all.map do |country|
  regions = country.subregions.map do |region|
    [region.name, region.code]
  end.sort_by { |e| e[0] }
  
  [country.name, country.code, regions]
end.sort_by { |e| e[0] }

case format
when 'json'
  puts JSON.generate(:data => data)

when 'php'
  template = <<-CODE
    var $data = array(
<% @data.each_with_index do |row, index| -%>
      '<%= row[1] %>' => array(
        'name' => "<%= row[0] %>",
        'regions' => array(
  <% regions = row[2]; regions.each_with_index do |region, rindex| -%>
          "<%= region[0] %>" => '<%= region[1] %>'<%= rindex < (regions.length-1) ? ',' : '' %>
  <% end %>
        )
      )<%= index < (@data.length-1) ? ',' : '' %>
<% end %>
    );
  CODE

  @data = data
  erb = ERB.new(template, nil, '-').result
  puts erb
end


