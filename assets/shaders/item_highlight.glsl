// Author: Daniel
// Title: Item outline
//https://blogs.love2d.org/content/let-it-glow-dynamically-adding-outlines-characters#code

#ifdef GL_ES
precision mediump float;
#endif

extern vec2 step_size;


vec4 effect(vec4 color, Image tex, vec2 texture_coords, vec2 screen_coords){
    vec2 step_size = vec2(0.001,0.001);
    vec4 texturecolor = texture2D(tex, texture_coords);

    float alpha =  4 * texturecolor.a;


    vec2 down = clamp(texture_coords-(0.0, step_size.y), 0.0, 1.0);
    vec2 up = clamp(texture_coords+(0.0, step_size.y), 0.0, 1.0);
    vec2 left = clamp(texture_coords-(step_size.x, 0.0), 0.0, 1.0);
    vec2 right = clamp(texture_coords+(step_size.x, 0.0), 0.0, 1.0);
    alpha = alpha  - texture2D(tex, down).a - texture2D(tex, up).a - texture2D(tex, left).a - texture2D(tex, right).a;


    vec4 result_col = vec4( 1.0f, 1.0f, 1.0f, alpha );
    return result_col;
}
