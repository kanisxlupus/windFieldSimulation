// make this 120 for the mac:
#version 330 compatibility

// out variables to be interpolated in the rasterizer and sent to each fragment shader:
out  vec3  vN;	  // normal vector
out  vec3  vL;	  // vector from point to light
out  vec3  vE;	  // vector from point to eye
out  vec3  vPos;  // Vertex Position

// where the light is:

const vec3 LightPosition = vec3(  0., 5., 5. );

void
main( )
{
	vec4 ECposition = gl_ModelViewMatrix * gl_Vertex;
	vN = normalize( gl_NormalMatrix * gl_Normal );  // normal vector
	vL = LightPosition - ECposition.xyz;	    // vector from the point
							// to the light position
	vE = vec3( 0., 0., 0. ) - ECposition.xyz;       // vector from the point
							// to the eye position

	vPos = gl_Vertex.xyz; 
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}
