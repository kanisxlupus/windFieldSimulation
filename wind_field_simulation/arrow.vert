// make this 120 for the mac:
#version 330 compatibility

// out variables to be interpolated in the rasterizer and sent to each fragment shader:
out  vec3  vN;	  // normal vector
out  vec3  vL;	  // vector from point to light
out  vec3  vE;	  // vector from point to eye
out  vec3  vPos;  // Vertex Position
out  vec4  noiseValue;

uniform sampler3D Noise3;
uniform float uPosX;
uniform float uPosY;
uniform float uPosZ;
uniform float uVolumeDiam;
uniform int uVolumeOffset;
uniform float uNumVoxels;
uniform float uNoiseContrast;

// where the light is:

const vec3 LightPosition = vec3(  0., 5., 5. );

const float PI = 3.14159265359;

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

	noiseValue = texture(Noise3, noiseCoords);

	// increase contrast on noise value
	vec3 inValue = noiseValue.xyz;
	vec3 remove = vec3(0.5, 0.5, 0.5);

	return noiseValue = vec4(mix(remove, inValue, uNoiseContrast), 1.);
}

void
main( )
{
	vec4 posOffset = vec4(uPosX, uPosY, uPosZ, 1.);

	noiseValue = getNoiseValue(posOffset.xyz);

	// get rotation angles
	float slopeXY = noiseValue.y / noiseValue.x;
	float slopeZX = noiseValue.x / noiseValue.z;

	float xAng = 2 * PI - atan(slopeXY);
	float yAng = atan(slopeZX);

	// create rotation matrices
	mat4 xRot = mat4(1.,	0.,			0.,			0., 
					 0.,	cos(xAng),	-sin(xAng),	0.,
					 0.,	sin(xAng),	cos(xAng),	0.,
					 0.,	0.,			0.,			1.);

	mat4 yRot = mat4(cos(yAng),		0.,		sin(yAng),	0.,
					 0.,			1.,		0.,			0.,
					 -sin(yAng),	0.,		cos(yAng),	0.,
					 0.,			0.,		0.,			1.);

	// multiply vertex position by rotation matrices
	vec4 pos = gl_Vertex;

	pos = pos * xRot * yRot;

	// scale the arrow based on the diameter of the voxel
	float voxelDiam = uVolumeDiam / uNumVoxels;

	mat4 scale = mat4(voxelDiam,	0.,			0.,			0.,
					  0.,			voxelDiam,	0.,			0.,
					  0.,			0.,			voxelDiam,	0.,
					  0.,			0.,			0.,			1.);
	pos *= scale;

	pos += posOffset;

	// Finish up
	vec4 ECposition = gl_ModelViewMatrix * pos;
	vN = normalize( gl_NormalMatrix * gl_Normal );  // normal vector
	vL = LightPosition - ECposition.xyz;			// vector from the point
							// to the light position
	vE = vec3( 0., 0., 0. ) - ECposition.xyz;       // vector from the point
							// to the eye position

	vPos = pos.xyz;

	gl_Position = gl_ModelViewProjectionMatrix * pos;
}