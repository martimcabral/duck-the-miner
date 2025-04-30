shader_type canvas_item;

uniform float blur_size = 2.0;
uniform float intensity = 1.2;

void fragment() {
    vec4 base_color = texture(TEXTURE, UV);
    vec4 glow = vec4(0.0);

    // Simple box blur around the current pixel
    for (int x = -2; x <= 2; x++) {
        for (int y = -2; y <= 2; y++) {
            vec2 offset = vec2(x, y) * blur_size / vec2(textureSize(TEXTURE, 0));
            glow += texture(TEXTURE, UV + offset);
        }
    }

    glow /= 25.0;
    glow *= intensity;

    COLOR = glow;
}
