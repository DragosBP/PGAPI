#version 330

// Input
in vec2 f_texture_coord;

// Uniform properties
uniform sampler2D texture_1;

// Output
layout(location = 0) out vec4 out_color;


void main()
{
    // TODO(student): Apply the texture
    out_color = texture(texture_1, f_texture_coord);

    // TODO(student): Discard when alpha component < 0.75
    if (out_color.a < 0.75)
        discard;

    // out_color = vec4(0.419, 0.584, 0.250, 0);
}
