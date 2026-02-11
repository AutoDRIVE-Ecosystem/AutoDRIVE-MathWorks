# Simulink API

<p align="justify">
This directory hosts the Simulink API for AutoDRIVE, which can be used to develop modular as well as end-to-end autonomous driving algorithms using graphical programming. This API is primarily designed for "system engineers" who prefer an interactive MBD/MBSE toolchain.
</p>

## SETUP

> [!NOTE]
> Please skip this setup if you have already installed the [`autodrive_matlab_api`](../autodrive_matlab_api).

1. Install the Java library:
   - Place the [`WebSocket-1.0.0.jar`](lib/target/WebSocket-1.0.0.jar) file on the static Java class path in MATLAB by editing the `javaclasspath.txt` file (create the file if it does not exist). Run the following in MATLAB Command Window:
     ```MATLAB
     edit(fullfile(prefdir,'javaclasspath.txt'))
     ```
     For example, if the location of the `jar` file is `C:\AutoDRIVE-MathWorks\autodrive_simulink_api\lib\target\WebSocket-1.0.0.jar`, then open the static class path file with the above command and add the full path to it. Make sure that there are no other lines with a `WebSocket-*` entry. You can refer to [MATLAB's Documentation](https://www.mathworks.com/help/matlab/matlab_external/static-path-of-java-class-path.html) for more information on the static Java class path.

     After having done this, **restart MATLAB** and check that the path was read by MATLAB properly by running the `javaclasspath` command. The newly added path should appear at the bottom of the list, before the `DYNAMIC JAVA PATH` entries. Note that seeing the entry here does not mean that MATLAB necessarily found the `jar` file properly. You must make sure that the actual `jar` file is indeed available at this location.
   - **[OPTIONAL]** To build the `jar` file yourself, it is recommended to use [Apache Maven](https://maven.apache.org/download.cgi) (tested with version 3.8.1) with [Java Development Kit](https://www.oracle.com/java/technologies/downloads/?er=221886#java8) (tested with version 8u411). Maven will automatically take care of downloading the [`Java-WebSocket`](https://github.com/TooTallNate/Java-WebSocket) library and neatly package everything into a single file (an "uber jar") based on the [`pom.xml`](lib/pom.xml). Once the `mvn` command is on your path, simply `cd` to the `lib` directory and execute the `mvn package` command.
2. Add the `autodrive_simulink_api` directory to MATLAB path by right-clicking on it from MATLAB's file explorer and selecting `Add to Path` &rarr; `Selected Folders and Subfolders`.

> [!NOTE]
> If you face issues installing/running the AutoDRIVE Simulink API or examples, check out the [Troubleshooting Guide](troubleshooting/README.md) for helpful tips.

## USAGE

Run the vehicle-specific `example` file (the first URL) with the corresponding vehicle-specific simulator (the second URL):
- [`example_roboracer.slx`](example_roboracer.slx) for [RoboRacer (formerly F1Tenth)](https://github.com/AutoDRIVE-Ecosystem/AutoDRIVE-MathWorks/releases/download/v0.2.0/autodrive_roboracer_simulator.zip)
- [`example_hunter.slx`](example_hunter.slx) for [AgileX Hunter SE](https://github.com/AutoDRIVE-Ecosystem/AutoDRIVE-MathWorks/releases/download/v0.4.0/autodrive_hunter_simulator.zip)
- [`example_husky.slx`](example_husky.slx) for [Clearpath Husky A200](https://github.com/AutoDRIVE-Ecosystem/AutoDRIVE-MathWorks/releases/download/v0.6.0/autodrive_husky_simulator.zip)
- [`example_rzr.slx`](example_rzr.slx) for [Polaris RZR Pro R 4 Ultimate](https://github.com/AutoDRIVE-Ecosystem/AutoDRIVE-MathWorks/releases/download/v0.8.0/autodrive_rzr_simulator.zip)

> [!NOTE]
> The AutoDRIVE Simulink API, which is implemented as a Level-2 MATLAB S-Function, will automatically take care of creating a WebSocket server instance upon running the Simulink model and will ensure a graceful exit upon termination by stopping the server instance, deleting it, and clearing it from the memory.
