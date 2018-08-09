#version 300 es

precision mediump int;
precision mediump float;

in ivec3 vertexPosition;
in ivec3 vertexNormal;
in vec4 vertexColor;

uniform mat4 vertexQuantizationMatrix;
uniform mat4 projectionMatrix;
uniform mat4 viewMatrix;
uniform mat3 viewNormalMatrix;

uniform LightData {
	vec3 dir;
	vec3 color;
	vec3 ambientColor;
	float intensity;
} lightData;

out mediump vec4 color;

void main(void) {

    vec4 floatVertex = vertexQuantizationMatrix * vec4(float(vertexPosition.x), float(vertexPosition.y), float(vertexPosition.z), 1);
    vec3 viewNormal = normalize(viewNormalMatrix * vec3(float(vertexNormal.x) / 127.0, float(vertexNormal.y) / 127.0, float(vertexNormal.z) / 127.0));
    float lambertian = max(dot(-viewNormal, normalize(lightData.dir)), 0.0);

    gl_Position = projectionMatrix * viewMatrix * floatVertex;
    color = vec4(lightData.ambientColor +  (lambertian * (lightData.color + vertexColor.rgb)), vertexColor.a);
}