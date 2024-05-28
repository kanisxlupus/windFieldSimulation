// make this 120 for the mac:
#version 330 compatibility

// in variables from the vertex shader and interpolated in the rasterizer:
in  vec3  vN;		   // normal vector
in  vec3  vL;		   // vector from point to light
in  vec3  vE;		   // vector from point to eye
in  vec3  vPos;		   // vertex position

// Uniforms
uniform sampler3D Noise3;
uniform float uVolumeDiam;
uniform int uVolumeOffset;
uniform float uNumVoxels;
uniform float uNoiseContrast;

vec4 getNoiseValue(vec3 objectPos)
{
	// get vertex position on a scale of 0 -> 1
	vec3 scaledPos = objectPos;				// 0 + uVolumeOffset -> uVolumeDiam + uVolumeOffset
	scaledPos -= float(uVolumeOffset);		// 0 -> uVolumeDiam;
	scaledPos = scaledPos / uVolumeDiam;	// 0 -> 1;

	// Find voxel that the current fragment is part of
	float voxelDiam = 1. / uNumVoxels;
	float voxelRad = voxelDiam / 2.;

	int numInX = int(scaledPos.x / voxelDiam);
	int numInY = int(scaledPos.y / voxelDiam);
	int numInZ = int(scaledPos.z / voxelDiam);

	float xCenter = float(numInX) * voxelDiam + voxelRad;
	float yCenter = float(numInY) * voxelDiam + voxelRad;
	float zCenter = float(numInZ) * voxelDiam + voxelRad;

	// Get noise value of that voxel
	vec3 noiseCoords = vec3(xCenter, yCenter, zCenter);
	noiseCoords = normalize(noiseCoords);

	vec4 noiseValue = texture(Noise3, noiseCoords);

	// increase contrast on noise value
	vec3 inValue = noiseValue.xyz;
	vec3 remove = vec3(0.5, 0.5, 0.5);

	return noiseValue = vec4(mix(remove, inValue, uNoiseContrast), 1.);
}

void
main( )
{
	
	gl_FragColor = getNoiseValue(vPos);

}

