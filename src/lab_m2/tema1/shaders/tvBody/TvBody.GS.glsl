#version 430

layout(lines) in;
layout(triangle_strip, max_vertices = 24) out;

uniform mat4 View;
uniform mat4 Projection;
uniform mat4 Model;

uniform float tv_length;

out vec2 texture_coord;
out vec3 world_position;
out vec3 world_normal;

void EmitVertexData(vec3 pos, vec3 normal, vec2 uv)
{
    vec4 world_pos = Model * vec4(pos, 1.0);
    world_position = world_pos.xyz;
    world_normal = mat3(Model) * normal;
    texture_coord = uv;
    gl_Position = Projection * View * world_pos;
    EmitVertex();
}

void main()
{
    float deltaL = tv_length / 2.0;

    // Z+
    EmitVertexData(vec3(-deltaL, -deltaL,  deltaL), vec3(0, 0, 1), vec2(0, 0));
    EmitVertexData(vec3( deltaL, -deltaL,  deltaL), vec3(0, 0, 1), vec2(1, 0));
    EmitVertexData(vec3(-deltaL,  deltaL,  deltaL), vec3(0, 0, 1), vec2(0, 1));
    EmitVertexData(vec3( deltaL,  deltaL,  deltaL), vec3(0, 0, 1), vec2(1, 1));
    EndPrimitive();

    // Z-
    EmitVertexData(vec3( deltaL, -deltaL, -deltaL), vec3(0, 0, -1), vec2(0, 0));
    EmitVertexData(vec3(-deltaL, -deltaL, -deltaL), vec3(0, 0, -1), vec2(1, 0));
    EmitVertexData(vec3( deltaL,  deltaL, -deltaL), vec3(0, 0, -1), vec2(0, 1));
    EmitVertexData(vec3(-deltaL,  deltaL, -deltaL), vec3(0, 0, -1), vec2(1, 1));
    EndPrimitive();

    // Y+
    EmitVertexData(vec3(-deltaL,  deltaL,  deltaL), vec3(0, 1, 0), vec2(0, 0));
    EmitVertexData(vec3( deltaL,  deltaL,  deltaL), vec3(0, 1, 0), vec2(1, 0));
    EmitVertexData(vec3(-deltaL,  deltaL, -deltaL), vec3(0, 1, 0), vec2(0, 1));
    EmitVertexData(vec3( deltaL,  deltaL, -deltaL), vec3(0, 1, 0), vec2(1, 1));
    EndPrimitive();

    // Y-
    EmitVertexData(vec3(-deltaL, -deltaL, -deltaL), vec3(0, -1, 0), vec2(0, 0));
    EmitVertexData(vec3( deltaL, -deltaL, -deltaL), vec3(0, -1, 0), vec2(1, 0));
    EmitVertexData(vec3(-deltaL, -deltaL,  deltaL), vec3(0, -1, 0), vec2(0, 1));
    EmitVertexData(vec3( deltaL, -deltaL,  deltaL), vec3(0, -1, 0), vec2(1, 1));
    EndPrimitive();

    // X+
    EmitVertexData(vec3( deltaL, -deltaL,  deltaL), vec3(1, 0, 0), vec2(0, 0));
    EmitVertexData(vec3( deltaL, -deltaL, -deltaL), vec3(1, 0, 0), vec2(1, 0));
    EmitVertexData(vec3( deltaL,  deltaL,  deltaL), vec3(1, 0, 0), vec2(0, 1));
    EmitVertexData(vec3( deltaL,  deltaL, -deltaL), vec3(1, 0, 0), vec2(1, 1));
    EndPrimitive();

    // X-
    EmitVertexData(vec3(-deltaL, -deltaL, -deltaL), vec3(-1, 0, 0), vec2(0, 0));
    EmitVertexData(vec3(-deltaL, -deltaL,  deltaL), vec3(-1, 0, 0), vec2(1, 0));
    EmitVertexData(vec3(-deltaL,  deltaL, -deltaL), vec3(-1, 0, 0), vec2(0, 1));
    EmitVertexData(vec3(-deltaL,  deltaL,  deltaL), vec3(-1, 0, 0), vec2(1, 1));
    EndPrimitive();
}
