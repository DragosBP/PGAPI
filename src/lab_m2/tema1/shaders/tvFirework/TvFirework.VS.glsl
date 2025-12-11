#version 430

// Input (not used for particles - we use SSBO)
layout(location = 0) in vec3 v_position;
layout(location = 1) in vec3 v_normal;
layout(location = 2) in vec2 v_texture_coord;

// Uniform properties
uniform mat4 Model;
uniform vec3 generator_position;
uniform float deltaTime;

// Output to geometry shader
out float vert_lifetime;
out float vert_iLifetime;
out vec3 vert_color;

// Particle data structure
struct Particle
{
    vec4 position;
    vec4 speed;
    vec4 iposition;
    vec4 ispeed;
    float delay;
    float iDelay;
    float lifetime;
    float iLifetime;
    int state;
    vec4 color;
};

layout(std430, binding = 0) buffer particles {
    Particle data[];
};

float rand(vec2 co)
{
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void main()
{
    vec3 pos = data[gl_VertexID].position.xyz;
    vec3 spd = data[gl_VertexID].speed.xyz;

    float lifetime = data[gl_VertexID].lifetime;
    float iLifetime = data[gl_VertexID].iLifetime;
    
    vec4 color = data[gl_VertexID].color;

    int state = data[gl_VertexID].state;

    float dt = deltaTime;

    vec3 gravity = vec3(0, -0.9, 0); 
    pos = pos + spd * dt + gravity * dt * dt / 2.0f;
    spd = spd + gravity * dt;

    if (state == 0 && spd.y <= 0)
    {
        state = 1;

        float seed = float(gl_VertexID);
        
        float rx = rand(vec2(seed, 13.0)) * 2.0 - 1.0; 
        float ry = rand(vec2(seed, 17.0)) * 2.0 - 1.0;
        float rz = rand(vec2(seed, 23.0)) * 2.0 - 1.0;
        
        vec3 direction = normalize(vec3(rx, ry, rz));

        float magnitude = rand(vec2(seed, 29.0)) + 0.5;

        spd = direction * magnitude;
    }

    lifetime -= dt;

    if (lifetime <= 0) 
    {
        pos = data[gl_VertexID].iposition.xyz;
        spd = data[gl_VertexID].ispeed.xyz;

        lifetime = data[gl_VertexID].iLifetime;
        
        float r = rand(vec2(color.r + 1.0, color.g + 2.0));
        float g = rand(vec2(color.g + 3.0, color.b + 4.0));
        float b = rand(vec2(color.b + 5.0, color.r + 6.0));
        color = vec4(r, g, b, 1.0);
        
        state = 0;
    }

    data[gl_VertexID].position.xyz = pos;
    data[gl_VertexID].speed.xyz = spd;
    data[gl_VertexID].lifetime = lifetime;
    data[gl_VertexID].color = color;
    data[gl_VertexID].state = state;

    vert_lifetime = lifetime;
    vert_iLifetime = iLifetime;
    vert_color = color.rgb;

    vec3 finalPos = pos + generator_position;

    // So the particles do not come out of the left side of the screen
    vec3 roatedPos = vec3(finalPos.y, -finalPos.x, finalPos.z);

    gl_Position = Model * vec4(roatedPos, 1.0);
}