#version 430

// Input (not used for particles - we use SSBO)
layout(location = 0) in vec3 v_position;
layout(location = 1) in vec3 v_normal;
layout(location = 2) in vec2 v_texture_coord;

// Uniform properties
uniform mat4 Model;
uniform vec3 generator_position;
uniform float deltaTime;
uniform float time;

// Output to geometry shader
out float vert_lifetime;
out float vert_iLifetime;

// Particle data structure (must match CPU side)
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
};

// Shader Storage Buffer for particles
layout(std430, binding = 0) buffer particles {
    Particle data[];
};

float rand(vec2 co)
{
    return fract(sin(dot(co.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

void main()
{
    // Get particle data
    vec3 pos = data[gl_VertexID].position.xyz;
    vec3 spd = data[gl_VertexID].speed.xyz;
    float lifetime = data[gl_VertexID].lifetime;
    float iLifetime = data[gl_VertexID].iLifetime;

    float dt = deltaTime;

    // Update position with gravity (3D movement)
    pos.x = pos.x + spd.x * dt;
    pos.y = pos.y + spd.y * dt - 0.5 * dt * dt * 2.0; // Gravity pulls down
    pos.z = pos.z + spd.z * dt;  // Z movement (depth)
    
    // Update speed (apply gravity to Y, slight drag on X and Z)
    spd.x = spd.x * 0.995;  // Air resistance
    spd.y = spd.y - 2.0 * dt;  // Gravity
    spd.z = spd.z * 0.995;  // Air resistance
    
    // Update lifetime
    lifetime -= dt;

    // Reset particle when lifetime expires or goes off screen
    if (lifetime <= 0 || pos.y < -1.2)
    {
        pos = data[gl_VertexID].iposition.xyz;
        spd = data[gl_VertexID].ispeed.xyz;
        lifetime = data[gl_VertexID].iLifetime;
        
        // Add randomness to respawn position and speed
        float randVal = rand(pos.xy + vec2(time));
        pos.x += (randVal - 0.5) * 0.2;
        spd.x = data[gl_VertexID].ispeed.x * (0.8 + rand(pos.yx + vec2(time)) * 0.4);
        spd.y = data[gl_VertexID].ispeed.y * (0.8 + rand(pos.xy * 2.0 + vec2(time)) * 0.4);
        spd.z = data[gl_VertexID].ispeed.z * (0.8 + rand(pos.xz + vec2(time)) * 0.4);
    }

    // Write back updated values
    data[gl_VertexID].position.xyz = pos;
    data[gl_VertexID].speed.xyz = spd;
    data[gl_VertexID].lifetime = lifetime;

    // Pass lifetime to geometry shader
    vert_lifetime = lifetime;
    vert_iLifetime = iLifetime;

    // Output 3D position - Z will be used for depth/size effect in GS
    gl_Position = vec4(pos + generator_position, 1.0);
}
