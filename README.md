<h1 align="center"> Wind Field Simulation </h1>
<p align="center"> by Samantha Jones </p>

---
# Program Description

This project is a wind field simulation that takes values from 3D Perlin noise, converts them to usable direction vectors within a bounding box, and uses them to apply force to a particle system. I also implemented a GUI that allows the user to toggle several visualization tools on and off.

This program utilizes five shader programs to achieve its desired results, as well as a robust GLUI menu system for the GUI. The shader programs are as follows:
•	VoxelOutline – A simple shader program that displays the outline of the program’s bounding voxels. 
•	Display Noise – Applies the 3D noise texture to a point cloud to allow for visualization of the texture as a volume when split into voxels.
•	DrawArrow – Draws arrows at the center of each voxel, rotates them so they point in the direction of their corresponding noise value, and scales them relative to the size of their voxel.
•	ComputeParticles – A compute shader that moves particles in space along their direction vector determined by which voxel they are located within.
•	RenderParticles – A simple shader program that renders the particle system with per-fragment lighting.

## Noise Sampling Logic
The wind field is applied to a bounding volume cube in space and is segmented by voxels within that volume. Both the edge length of the bounding volume and the number of voxels that segment it defined by variables and are adjustable via spinners in the GUI. Below is an example of a volume with an edge length of 20 and two voxels per edge:

** INSERT BOUNDING VOLUME PHOTO**

Objects in space within the bounding volume make a check to see which voxel they are in, and then sample a noise value from the texture based on the center point of their respective voxel. Here is an example of the same volume and its corresponding noise value represented by a point cloud:

** INSERT POINT CLOUD PHOTO**

Once the noise value has been obtained for a given voxel, a contrast mix is applied to the value to exaggerate the direction of the vector. Here are some examples of the value of the vector pre and post contrast:

** INSERT PRE AND POST CONTRAST PC PHOTOS**

And here is an example of how the contrast affects the direction vector in terms of its force:

** INSERT PRE AND POST CONTRAST ARROW PHOTOS**

Once the vector has had a contrast applied to it, it’s ready to be used. In order to visualize the movement, I created a particle system using a compute shader, and I apply a corresponding modified noise value to each particle on each frame. It’s better illustrated in video, but here’s a screenshot anyway:

This noise sampling logic is implemented in the `getNoiseValue()` function, which is utilized throughout the shaders in the program.

## Shader Walkthrough
The noise sampling logic is utilized in the **DisplayNoise**, **DrawArrow**, and **ComputeParticles** shaders, and is used in the following ways:
•	**DisplayNoise** implements this logic in the fragment shader in order to set gl_FragColor
•	**DrawArrow** implements this logic in the vertex shader. It gets the modified noise value, computes the angle of the noise vector on the ZX and XY planes to find the corresponding X and Y rotations for the arrow, constructs two rotation matrices, and multiplies the vertex position by them both. It also applies a scale matrix so that the arrow will scale with the edge length of its corresponding voxel. Finally, it passes the modified noise value into the fragment shader to be used as the arrow’s frag color.
•	**ComputeParticles** implements this logic in a compute shader. The compute shader gets the corresponding noise value based on the vertex’s current position, which is stored in a struct within the shader storage buffer object. The noise value is then multiplied by a wind speed value, and added to the current vertex position. The compute shader then checks to see if the vertex has been moved outside the range of the volume, and if it has, it is returned to its position of origin.

# Example Video
This program is difficult to demonstrate via video because of particle speed, but [here's an example video anyway](https://media.oregonstate.edu/media/1_vwqeabfv).


