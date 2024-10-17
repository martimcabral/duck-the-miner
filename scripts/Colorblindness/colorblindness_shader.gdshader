shader_type canvas_item;

// Define the screen texture using hint_screen_texture
uniform sampler2D screen_tex : hint_screen_texture, filter_linear_mipmap; // This holds the entire screen as a texture

// Mode control for colorblindness simulation (0 = Normal, 1 = Deuteranopia, 2 = Protanopia, 3 = Tritanopia, 4 = Achromatopsia)
uniform int mode;

void fragment() {
    // Sample the current pixel color from the screen texture using UV coordinates
    vec4 color = texture(screen_tex, SCREEN_UV);
    
    // Declarre a vector to store the corrected color
    vec3 corrected;

    // Check the value of 'mode' to apply the appropriate colorblindness correction
    if (mode == 1) { // Deuteranopia (Red-Green color blindness)
        // Red is blended with green, and green is adjusted based on blue to simulate how people with Deuteranopia perceive colors
        corrected.r = 0.625 * color.r + 0.375 * color.g;
        corrected.g = 0.7 * color.g + 0.3 * color.b;
        corrected.b = color.b; // Blue remains unchanged
    }
    else if (mode == 2) { // Protanopia (Another type of Red-Green color blindness)
        // Red is more blended with green here, with similar changes to the green channel
        corrected.r = 0.567 * color.r + 0.433 * color.g;
        corrected.g = 0.558 * color.g + 0.442 * color.b;
        corrected.b = color.b; // Blue remains unchanged
    }
    else if (mode == 3) { // Tritanopia (Blue-Yellow color blindness)
        // Red remains unchanged, but green and blue are blended differently to simulate Tritanopia
        corrected.r = color.r;
        corrected.g = 0.55 * color.g + 0.45 * color.b;
        corrected.b = 0.475 * color.b + 0.525 * color.g;
    }
    else if (mode == 4) { // Achromatopsia (Total color blindness - Grayscale)
        // All color channels are converted to grayscale using the standard luminance formula
        float gray = 0.299 * color.r + 0.587 * color.g + 0.114 * color.b;
        corrected = vec3(gray, gray, gray); // Set all channels (r, g, b) to the calculated gray value
    }
    else { // Normal vision (No correction)
        corrected = color.rgb; // Output the original color unmodified
    }

    // Set the final output color, maintaining the original alpha value from the screen texture
    COLOR = vec4(corrected, color.a);
}
