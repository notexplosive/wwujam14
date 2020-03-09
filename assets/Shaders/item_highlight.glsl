// Author: Daniel
// Title: Item outline
//https://blogs.love2d.org/content/let-it-glow-dynamically-adding-outlines-characters#code

#ifdef GL_ES
precision mediump float;
#endif

const vec2 step_size;

//extern, pass in screen size
uniform vec2 screen;

    vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords)
    {
        vec4 texturecolor = texture2D(tex, texture_coords);
        vec4 result_col = vec4(1.0,1.0,1.0,texturecolor.a);
        float alpha =  My_Alpha(tex, texture_coords);

        texturecolor = texturecolor + result_col;
        texturecolor =clamp(texturecolor, 0.0, 1.0)
        return texturecolor
    }

    float My_Alpha(Image tex, vec2 texture_coords){
      vec4 texturecolor = texture2D(tex, texture_coords);
      float alpha = 4 * texturecolor.a;
      vec2 down = clamp(texture_coords-(0.0, step_size.y), 0.0, 1.0);
      vec2 up = clamp(texture_coords+(0.0, step_size.y), 0.0, 1.0);
      vec2 left = clamp(texture_coords-(step_size.x, 0.0), 0.0, 1.0);
      vec2 right = clamp(texture_coords+(step_size.x, 0.0), 0.0, 1.0);
      alpha = alpha  - texture2D(tex, down).a - texture2D(tex, up).a
      - texture2D(tex, left).a - texture2D(tex, right).a;

      return alpha;
    }


}
