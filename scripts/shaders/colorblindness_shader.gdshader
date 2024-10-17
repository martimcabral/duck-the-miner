shader_type canvas_item;

// Define the screen texture using hint_screen_texture
uniform sampler2D screen_tex : hint_screen_texture, filter_linear_mipmap;

// Mode control for colorblindness
uniform int mode;

void fragment() {
    // Get the color from the screen
    vec4 color = texture(screen_tex, SCREEN_UV);
    vec3 corrected;

    // Apply colorblindness corrections
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

    // Set the final output color
    COLOR = vec4(corrected, color.a);
}
