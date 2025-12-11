#version 430

// Input: points from vertex shader
layout(points) in;

// Output: quad as triangle strip
layout(triangle_strip, max_vertices = 4) out;

// Uniform properties
uniform float offset;

// Input from vertex shader
in float vert_lifetime[1];
in float vert_iLifetime[1];
in vec3 vert_color[1];

// Output to fragment shader
layout(location = 0) out vec2 texture_coord;
layout(location = 1) out float geom_lifetime;
layout(location = 2) out float geom_iLifetime;
layout(location = 3) out vec3 geom_color;


void main()
{
    vec3 pos = gl_in[0].gl_Position.xyz;
    
    geom_lifetime = vert_lifetime[0];
    geom_iLifetime = vert_iLifetime[0];
    
    float lifetimeRatio = vert_lifetime[0] / vert_iLifetime[0];
    
    float depthScale = 1.0 / (1.0 + pos.z * 0.5);  // Perspective effect
    depthScale = clamp(depthScale, 0.3, 2.0);      // Limit the range
    
    float size = offset * (0.5 + lifetimeRatio * 0.5) * depthScale;
    
    float screenX = pos.x * depthScale;
    float screenY = pos.y * depthScale;
    float depth = pos.z * 0.1;  // Normalize Z for depth buffer
    
    geom_color = vert_color[0];

    // Bottom-left
    texture_coord = vec2(0, 0);
    gl_Position = vec4(screenX - size, screenY - size, depth, 1);
    EmitVertex();
    
    // Bottom-right
    texture_coord = vec2(1, 0);
    gl_Position = vec4(screenX + size, screenY - size, depth, 1);
    EmitVertex();
    
    // Top-left
    texture_coord = vec2(0, 1);
    gl_Position = vec4(screenX - size, screenY + size, depth, 1);
    EmitVertex();
    
    // Top-right
    texture_coord = vec2(1, 1);
    gl_Position = vec4(screenX + size, screenY + size, depth, 1);
    EmitVertex();
    
    EndPrimitive();
}