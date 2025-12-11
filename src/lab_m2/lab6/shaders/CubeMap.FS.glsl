#version 330

// Input
in vec3 world_position;
in vec3 world_normal;

// Uniform properties
uniform samplerCube texture_cubemap;
uniform int type;

uniform vec3 camera_position;

// Output
layout(location = 0) out vec4 out_color;


vec3 myReflect()
{
    // TODO(student): Compute the reflection color value
    vec3 view_direction = normalize(world_position - camera_position);
    vec3 reflect_direction = reflect(view_direction, normalize(world_normal));
    return texture(texture_cubemap, reflect_direction).rgb;

}


vec3 myRefract(float refractive_index)
{
    // TODO(student): Compute the refraction color value
    vec3 view_direction = normalize(world_position - camera_position);
    vec3 refract_direction = refract(view_direction, normalize(world_normal), 1/refractive_index);
    return texture(texture_cubemap, refract_direction).rgb;
}


void main()
{

    if (type == 0)
    {
        out_color = vec4(myReflect(), 0);
    }
    else
    {
        out_color = vec4(myRefract(1.33), 0);
    }
}

else if (debug_mode == 5) {
                // Show cubemap sample directly
                color = cubemap_color;
            } 
