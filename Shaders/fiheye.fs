#version 330

in vec2 fragTexCoord;
in vec4 fragColor;

uniform sampler2D texture0;
uniform vec4 colDiffuse;
uniform vec2 resolution;

out vec4 finalColor;

const float k = -0.2;

void main()
{
    vec2 uv = gl_FragCoord.xy / resolution;
    vec2 p = uv * 2.0 - 1.0;

    float r2 = dot(p, p);
    p *= (1.0 + k * r2) / (1.0 + k);

    vec2 uvDist = p * 0.5 + 0.5;
    vec2 d = uvDist - uv;

    vec2 scale = vec2(dFdx(fragTexCoord.x), dFdy(fragTexCoord.y)) * resolution;
    vec2 coord = fragTexCoord + d * scale;

    if (coord.x < 0.0 || coord.x > 1.0 || coord.y < 0.0 || coord.y > 1.0)
    {
        finalColor = vec4(0.0, 0.0, 0.0, 0.0);
        return;
    }

    finalColor = texture(texture0, coord) * colDiffuse * fragColor;
}