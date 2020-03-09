// Author:
// Title:

//MAX NUM lightdist
#define NUM_LIGHTS 32
#ifdef GL_ES
precision mediump float;
#endif

uniform vec2 u_resolution;

struct Light{
  vec2 pos;
  vec3 diffuse;
  float intensity; //radius/
};

//extern
int num_lights_in;

//extern, pass in screen size
uniform vec2 screen;

const float constant = 1.0;
const float linear = 0.09;
const float quadratic = 0.032;

//extern
  //ARRAY OF ALL LIGHTS
Light lights[NUM_LIGHTS];

    vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
    {
        vec4 texturecolor = VideoTexel(texture_coords);

        //normalize screen screen_coords
        vec2 norm_screen = normalize(screen_coords/screen);
        vec4 diffuse = vec4(0,0,0,1);

        for(int i = 0; i < num_lights_in; i++){
          vec2 norm_pos = lights[i].pos /screen;
          float this_distance = length(norm_pos - norm_screen);
          float attenuation = 1.0/(const + linear * this_distance
            + quadratic * this_distance * this_distance);
          diffuse += lights[i].diffuse * attenuation;
          diffuse = clamp(diffuse, 0.0, 1.0);
        }

        return texturecolor + diffuse;
    }
}
