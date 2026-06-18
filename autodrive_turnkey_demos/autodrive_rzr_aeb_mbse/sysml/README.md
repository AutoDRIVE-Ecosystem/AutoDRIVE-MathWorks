# Export Project as a SysML v2 File

Export a hierarchical system architecture (Simulink models of different systems, subsystems, components, and their variants, etc.) as a SysML v2 textual file.

## Example

A MATLAB live script, [`sysml.mlx`](sysml.mlx), within this directory serves as an example to export the components `{'Perception', 'Planning', 'Control', 'Simulation'}` as well as requirements `{'Detection', 'Comfort', 'Tracking', 'Safety'}` of the `AutoDRIVE_RZR_AEB` system architecture as a SysML v2 textual file.

## Reference

MathWorks Documentation:
- [Create Projects](https://www.mathworks.com/help/matlab/matlab_prog/create-projects.html)
- [systemcomposer.sysml.exportFromMLProject](https://www.mathworks.com/help/systemcomposer/ref/systemcomposer.sysml.exportfrommlproject.html)