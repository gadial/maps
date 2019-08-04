from yattag import Doc

map_path = 'svg_map.svg'
final_html = 'svg_map.html'

#open svg file
with open(map_path, 'r') as file:
    svg_map = file.read()

#create html
doc, tag, text, line= Doc().ttl()

doc.asis('<!DOCTYPE html>')

with tag('html'):
	with tag('head'):
		with tag('title'):
			text('Blog Map')
		with tag('link'):
			doc.attr(rel="stylesheet", type="text/css", href="svg_map.css")
	with tag('body'):
	    doc.asis(svg_map)
	with tag('script'):
		doc.attr(src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.1/jquery.min.js")
	with tag('script'):
		doc.attr(src="svg_map.js")


result = doc.getvalue()

with open(final_html, 'w') as file:
    file.write(result)