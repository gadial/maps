require "rexml/document"
include REXML
xmlfile = File.new("map.svg")
xmldoc = Document.new(xmlfile)

$specific_elements = {
    'filters' => "/svg/defs/g[@id='filters']",
    'rivers' => "/svg/g[@id='viewbox']/g[@id='rivers']"
}

$elements_to_filter = ['filters', 'rivers']

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
    html = '<!DOCTYPE html><html><head><title>Blog Map</title><link rel="stylesheet" type="text/css" href="svg_map.css"></link></head><body>{{ svg }}</body></html>'
    html.gsub!("{{ svg }}", xmldoc.to_s)
    File.open("map.html", "w") {|f| f.write(html)}
end

filter_out(xmldoc, $elements_to_filter)
show_structure(xmldoc)
write_html(xmldoc)