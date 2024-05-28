// make this 120 for the mac:
#version 330 compatibility


void
main( )
{
	gl_Position = gl_ModelViewProjectionMatrix * gl_Vertex;
}