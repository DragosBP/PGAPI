#version 430

// Input from geometry shader
layout(location = 0) in vec2 texture_coord;
layout(location = 1) in float geom_lifetime;
layout(location = 2) in float geom_iLifetime;
layout(location = 3) in vec3 geom_color; // <--- Received from GS

// Output
layout(location = 0) out vec4 out_color;

void main()
{
    
    out_color = vec4(geom_color, 1.0);
}