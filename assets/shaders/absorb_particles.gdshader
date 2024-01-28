shader_type canvas_item;

uniform float trail_length : hint_range(0.1, 1.0) = 1.5;

void vertex() {
    // Calculate the position manually based on the screen size
    vec2 frag_coord = vec2(1280.0 / 2.0, 720.0 / 2.0);

    // Modify the alpha based on the position
    COLOR.a = 1.0 - (frag_coord.x / 1280.0) * trail_length;
}