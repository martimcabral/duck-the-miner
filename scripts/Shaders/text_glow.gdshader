shader_type canvas_item;

uniform vec4 outline_color : source_color = vec4(1.0, 1.0, 0.0, 1.0); // Yellow glow
uniform float outline_size = 3.0;

void fragment() {
    vec4 base_color = texture(TEXTURE, UV);
    float alpha = base_color.a;

    if (alpha < 0.1) {
        float glow = 0.0;
        for (float x = -outline_size; x <= outline_size; x++) {
            for (float y = -outline_size; y <= outline_size; y++) {
                vec2 offset = vec2(x, y) / TEXTURE_PIXEL_SIZE;
                glow += texture(TEXTURE, UV + offset).a;
            }
        }
        glow = clamp(glow / pow((outline_size * 2.0 + 1.0), 2.0), 0.0, 1.0);
        COLOR = vec4(outline_color.rgb, glow * outline_color.a);
    } else {
        COLOR = base_color;
    }
}
