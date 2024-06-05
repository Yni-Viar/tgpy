/**
* Replace a color by another one.
* License: CC0
* https://creativecommons.org/publicdomain/zero/1.0/
*/

shader_type canvas_item;

uniform vec4 remove_color: source_color;

uniform vec4 replace_color: source_color;

void fragment(){
	vec4 col = texture(TEXTURE, UV);
	if (col.rgb == remove_color.rgb){
		col = replace_color;
	}
	COLOR = col;
}