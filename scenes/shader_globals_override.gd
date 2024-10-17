extends ShaderGlobalsOverride
shader_type canvas_item;

uniform int mode : hint_enum(["Normal", "Deuteranopia", "Protanopia", "Tritanopia", "Achromatopsia"]);

void fragment() {
	vec4 color = texture(TEXTURE, UV);
	vec3 corrected;

	if (mode == 1) { // Deuteranopia
		corrected.r = 0.625 * color.r + 0.375 * color.g;
		corrected.g = 0.7 * color.g + 0.3 * color.b;
		corrected.b = color.b;
	}
	else if (mode == 2) { // Protanopia
		corrected.r = 0.567 * color.r + 0.433 * color.g;
		corrected.g = 0.558 * color.g + 0.442 * color.b;
		corrected.b = color.b;
	}
	else if (mode == 3) { // Tritanopia
		corrected.r = color.r;
		corrected.g = 0.55 * color.g + 0.45 * color.b;
		corrected.b = 0.475 * color.b + 0.525 * color.g;
	} 
	else if (mode == 4) { // Achromatopsia (Grayscale)
		float gray = 0.299 * color.r + 0.587 * color.g + 0.114 * color.b;
		corrected = vec3(gray, gray, gray);
	}
	else { // Normal vision
		corrected = color.rgb;
	}

	COLOR = vec4(corrected, color.a);
}
