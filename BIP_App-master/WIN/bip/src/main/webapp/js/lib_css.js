// CSS Function
// returns CSS syntax for generated layers
// 19990326

// Copyright (C) 1999 Dan Steinman
// Distributed under the terms of the GNU Library General Public License
// Available at http://www.dansteinman.com/dynapi/

function css(id, left, top, width, height, clip_area, z, overflow_area, color, vis, other) {
	if (id=="START") return '<STYLE TYPE="text/css">\n'
	else if (id=="END") return '</STYLE>'
	var str = (left!=null && top!=null)? '#'+id+' {position:absolute; left:'+left+'; top:'+top+';' : '#'+id+' {position:relative;'
	if (arguments.length>=4 && width!=null) str += ' width:'+width+';'
	if (arguments.length>=5 && height!=null) str += ' height:'+height+';'
	if (arguments.length>=6 && clip_area!=null) str += ' clip:'+clip_area+';'	
	if (arguments.length>=7 && z!=null) str += ' z-index:'+z+';'
	if (arguments.length>=8 && overflow_area!=null) str += ' overflow:'+overflow_area+';'
	if (arguments.length>=9 && color!=null) str += (document.layers)? ' layer-background-color:'+color+';' : ' background-color:'+color+';'
	if (arguments.length>=10 && vis!=null) str += ' visibility:'+vis+';'

	if (arguments.length==11 && other!=null) str += ' '+other
	str += '}\n'
	return str
}
function writeCSS(str,showAlert) {
	document.write(str)
	if (showAlert) alert(str)
}
