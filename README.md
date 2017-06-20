# fltkhs-gl-demos
Demos showing how to integrate OpenGL with [FLTKHS](https://hackage.haskell.org/package/fltkhs).

To install make sure OpenGL libraries are available. This should only be an issue on Linux, 
currently OpenGL libraries are available out of the box on OSX and Windows 10. Then run:

    > stack build --flag fltkhs:bundled --flag fltkhs:opengl
