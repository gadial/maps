require "rexml/document"
include REXML
xmlfile = File.new("map.svg")
xmldoc = Document.new(xmlfile)

$specific_elements = {
    'filters' => "/svg/defs/g[@id='filters']",
    'rivers' => "/svg/g[@id='viewbox']/g[@id='rivers']",
    'routes' => "/svg/g[@id='viewbox']/g[@id='routes']",
    'regions' => "/svg/g[@id='viewbox']/g[@id='regions']",
    'states_body' => "/svg/g[@id='viewbox']/g[@id='regions']/g[@id='statesBody']",
    'definitions' => "/svg/defs"
}

$elements_to_filter = ['filters', 'rivers', 'routes', 'definitions']

def show_structure(xmldoc)
    xmldoc.elements.each("//*") do |element|
        puts "#{element.xpath}: #{element['id']}"
    end
end

def filter_out(xmldoc, elements_to_filter)
    for e in elements_to_filter do
        xmldoc.delete_element $specific_elements[e]
    end
end

def write_html(xmldoc)
    html = '<!DOCTYPE html><html><head><title>Blog Map</title><link rel="stylesheet" type="text/css" href="svg_map.css"></link><script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js"></script><script src="svg-pan-zoom.min.js"></script><script src="map.js"></script></head><body>{{ svg }}</body></html>'
    html.gsub!("{{ svg }}", xmldoc.to_s)
    File.open("map.html", "w") {|f| f.write(html)}
end

def change_style(element)
    new_style = yield(element['style'])
    element.add_attribute('style', new_style)
end

#filter_out(xmldoc, $elements_to_filter)
for element in ['states_body', 'regions'] do
    change_style(xmldoc.elements[$specific_elements[element]]) {|style| style.gsub('pointer-events:none;','')}
end

for state in xmldoc.elements[$specific_elements['states_body']] do
    if state['id'] =~ /state\d+/
        state.add_attribute('class', 'state') 
    end
end

show_structure(xmldoc)
write_html(xmldoc)