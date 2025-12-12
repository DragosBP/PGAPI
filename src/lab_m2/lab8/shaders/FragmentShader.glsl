#version 330

// Input
in vec2 texture_coord;

// Uniform properties
uniform sampler2D textureImage;
uniform ivec2 screenSize;
uniform int flipVertical;
uniform int outputMode = 2; // 0: original, 1: grayscale, 2: blur

// Output
layout(location = 0) out vec4 out_color;

// Local variables
vec2 textureCoord = vec2(texture_coord.x, (flipVertical != 0) ? 1 - texture_coord.y : texture_coord.y); // Flip texture


vec4 grayscale()
{
    vec4 color = texture(textureImage, textureCoord);
    float gray = 0.21 * color.r + 0.71 * color.g + 0.07 * color.b; 
    return vec4(gray, gray, gray,  0);
}

vec4 colorgrayscale(vec4 old_color) {
    float gray = 0.21 * old_color.r + 0.71 * old_color.g + 0.07 * old_color.b; 
    return vec4(gray, gray, gray,  0);
}

vec4 blur_grayscale(int blurRadius) {
    vec2 texelSize = 1.0f / screenSize;
    vec4 sum = vec4(0);
    for(int i = -blurRadius; i <= blurRadius; i++)
    {
        for(int j = -blurRadius; j <= blurRadius; j++)
        {
            sum += texture(textureImage, textureCoord + vec2(i, j) * texelSize);
        }
    }
        
    float samples = pow((2 * blurRadius + 1), 2);
    vec4 blurimage = sum / samples;
    
    float gray = 0.21 * blurimage.r + 0.71 * blurimage.g + 0.07 * blurimage.b; 
    return vec4(gray, gray, gray,  0);
}

vec4 helper(int blurRadius, vec2 texture_coord) {
    vec2 texelSize = 1.0f / screenSize;
    vec4 sum = vec4(0);
    for(int i = -blurRadius; i <= blurRadius; i++)
    {
        for(int j = -blurRadius; j <= blurRadius; j++)
        {
            sum += texture(textureImage, texture_coord + vec2(i, j) * texelSize);
        }
    }
        
    float samples = pow((2 * blurRadius + 1), 2);
    vec4 blurimage = sum / samples;
    
    float gray = 0.21 * blurimage.r + 0.71 * blurimage.g + 0.07 * blurimage.b; 
    return vec4(gray, gray, gray,  0);
}


vec4 sobel(int blurRadius) {
    vec2 texelSize = 1.0f / screenSize;
    vec4 pixels[10];
    int nr = 0;

    for (int i = -1; i <= 1; i++) {
        for (int j = -1; j <= 1; j++) {
            pixels[nr] = helper(blurRadius, textureCoord + vec2(i, j) * texelSize);
            nr++;
        }
    }
    
   float dx = pixels[2].x + 2 * pixels[5].x + pixels[8].x - (pixels[0].x + 2 * pixels[3].x + pixels[6].x);
   float dy = pixels[0].x + 2 * pixels[1].x + pixels[2].x - (pixels[6].x + 2 * pixels[7].x + pixels[8].x);

   float delta = abs(dx) + abs(dy);

   if (delta > 0.5) return vec4(1, 1, 1, 1);

   return vec4(0, 0, 0, 1);
}

vec4 blur(int blurRadius)
{
    vec2 texelSize = 1.0f / screenSize;
    vec4 sum = vec4(0);
    for(int i = -blurRadius; i <= blurRadius; i++)
    {
        for(int j = -blurRadius; j <= blurRadius; j++)
        {
            sum += texture(textureImage, textureCoord + vec2(i, j) * texelSize);
        }
    }
        
    float samples = pow((2 * blurRadius + 1), 2);
    return sum / samples;
}


vec4 median()
{
    vec2 texelSize = 1.0f / screenSize;
    const int medianRadius = 6;
    const int numPixels = medianRadius * medianRadius;
    
    vec4 pixels[numPixels];
    int pos = 0; 

    for (int i = -medianRadius; i <= medianRadius; i++) {
        for (int j = -medianRadius; j <= medianRadius; j++) {
            pixels[pos++] = texture(textureImage, textureCoord + vec2(i, j) * texelSize);
        }
    }

    // Sort

    for (int i = 0; i < numPixels - 1; i++) {
        for (int j = i + 1; j < numPixels; j++) {
            float a = 0.21 * pixels[i].r + 0.71 * pixels[i].g + 0.07 * pixels[i].b; 
            float b = 0.21 * pixels[j].r + 0.71 * pixels[j].g + 0.07 * pixels[j].b;
            
            if (a > b) {
                vec4 aux = pixels[i];
                pixels[i] = pixels[j];
                pixels[j] = aux;
            }
        }
    }

    return pixels[numPixels / 2];
}


void main()
{
    switch (outputMode)
    {
        case 1:
        {
            out_color = grayscale();
            break;
        }

        case 2:
        {
            out_color = median();
            break;
        }

        case 3:
        {
            out_color = blur(2);
            break;
        }

        case 4:
        {
            out_color = blur_grayscale(2);


            break;
        }
        
        case 5:
        {
            out_color = sobel(2);
            
            break;
        }

        default:
            out_color = texture(textureImage, textureCoord);
            break;
    }
}
