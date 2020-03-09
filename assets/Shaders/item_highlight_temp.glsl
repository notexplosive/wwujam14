// Author: Daniel
// Title: Item outline
//https://blogs.love2d.org/content/let-it-glow-dynamically-adding-outlines-characters#code

vec4 resultCol;
vec4 textureCol;

extern vec2 stepSize;

vec4 effect( vec4 col, Image texture, vec2 texturePos, vec2 screenPos )
{
    vec4 textureCol = texture2D( texture, texturePos );
    vec4 result_col = vec4( 1.0f, 1.0f, 1.0f, textureCol.a );

    number alpha = 4*texture2D( texture, texturePos ).a;
    alpha -= texture2D( texture, texturePos + vec2( stepSize.x, 0.0f ) ).a + texture2D( texture, texturePos + vec2( -stepSize.x, 0.0f ) ).a
    + texture2D( texture, texturePos + vec2( 0.0f, stepSize.y ) ).a + texture2D( texture, texturePos + vec2( 0.0f, -stepSize.y ) ).a;

    result_col.a = alpha;
    result_col = result_col * 0.25;
    return result_col;
}
