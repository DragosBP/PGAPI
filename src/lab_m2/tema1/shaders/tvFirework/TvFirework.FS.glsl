#version 430

// Input from geometry shader
layout(location = 0) in vec2 texture_coord;
layout(location = 1) in float geom_lifetime;
layout(location = 2) in float geom_iLifetime;

// Uniform properties
uniform sampler2D texture_1;

// Output
layout(location = 0) out vec4 out_color;

void main()
{
    // Sample particle texture
    vec4 tex_color = texture(texture_1, texture_coord);
    
    // Calculate alpha based on lifetime (fade out as particle dies)
    float lifetimeRatio = geom_lifetime / geom_iLifetime;
    float alpha = tex_color.a * lifetimeRatio;
    
    // Discard nearly transparent pixels
    if (alpha < 0.01) {
        discard;
    }
    
    // Color gradient based on lifetime (hot colors when young, cooler when older)
    vec3 hotColor = vec3(1.0, 1.0, 0.8);    // White/yellow (very hot)
    vec3 warmColor = vec3(1.0, 0.6, 0.1);   // Orange
    vec3 coolColor = vec3(1.0, 0.2, 0.1);   // Red
    vec3 fadeColor = vec3(0.5, 0.1, 0.3);   // Dark red/purple (dying)
    
    vec3 particleColor;
    if (lifetimeRatio > 0.7) {
        // Hot phase
        particleColor = mix(warmColor, hotColor, (lifetimeRatio - 0.7) / 0.3);
    } else if (lifetimeRatio > 0.3) {
        // Warm phase
        particleColor = mix(coolColor, warmColor, (lifetimeRatio - 0.3) / 0.4);
    } else {
        // Cool/fade phase
        particleColor = mix(fadeColor, coolColor, lifetimeRatio / 0.3);
    }
    
    // Apply texture luminance to particle color
    float luminance = dot(tex_color.rgb, vec3(0.299, 0.587, 0.114));
    vec3 finalColor = particleColor * luminance * 2.0;
    
    // Add glow effect based on lifetime
    float glow = 1.0 + lifetimeRatio * 1.5;
    finalColor *= glow;
    
    out_color = vec4(finalColor, alpha);
}
