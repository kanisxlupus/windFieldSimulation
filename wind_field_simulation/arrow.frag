// make this 120 for the mac:
#version 330 compatibility

// in variables from the vertex shader and interpolated in the rasterizer:
in  vec3  vN;		   // normal vector
in  vec3  vL;		   // vector from point to light
in  vec3  vE;		   // vector from point to eye
in  vec3  vPos;		   // vertex position
in  vec4  noiseValue;  

// Uniforms
uniform sampler3D Noise3;
uniform float uVolumeDiam;
uniform int uVolumeOffset;
uniform float uNumVoxels;

void
main( )
{
	vec3 myColor = noiseValue.xyz;
	
	gl_FragColor = vec4(myColor, 1.);

}