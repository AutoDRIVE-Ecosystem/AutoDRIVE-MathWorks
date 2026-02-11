<p align="center">
<img src="media/AutoDRIVE-Logo.png" alt="AutoDRIVE" height="80"/> &nbsp;&nbsp;&nbsp;&nbsp;&nbsp; <img src="media/MathWorks-Logo.png" alt="MathWorks" height="80"/>
</p>

A comprehensive toolbox containing modular APIs and turnkey demos for autonomous driving using AutoDRIVE Ecosystem and MathWorks tool suite.

[![MATLAB File Exchange](https://www.mathworks.com/matlabcentral/images/matlab-file-exchange.svg)](https://www.mathworks.com/matlabcentral/fileexchange/183093-autodrive-toolbox)
[![GitHub](https://img.shields.io/badge/GitHub-blue?logo=github&logoColor=white&labelColor=gray)](https://github.com/AutoDRIVE-Ecosystem/AutoDRIVE-MathWorks)
![Github Stars](https://img.shields.io/github/stars/AutoDRIVE-Ecosystem/AutoDRIVE-MathWorks?style=flat&color=blue&label=Stars&logo=github&logoColor=white)
![Github Forks](https://img.shields.io/github/forks/AutoDRIVE-Ecosystem/AutoDRIVE-MathWorks?style=flat&color=blue&label=Forks&logo=github&logoColor=white)
![Github Downloads](https://img.shields.io/github/downloads/AutoDRIVE-Ecosystem/AutoDRIVE-MathWorks/total?style=flat&color=blue&label=Downloads&logo=github&logoColor=white)

# MATLAB API

<p align="justify">
This section describes the MATLAB API for AutoDRIVE, which can be used to develop modular as well as end-to-end autonomous driving algorithms using textual programming. This API is primarily designed for "software engineers" who prefer a script/function-based workflow.
</p>

## SETUP

> [!NOTE]
> Please skip this setup if you have already installed the [`autodrive_simulink_api`](autodrive_simulink_api).

1. Install the Java library:
   - Place the [`WebSocket-1.0.0.jar`](autodrive_matlab_api/lib/target/WebSocket-1.0.0.jar) file on the static Java class path in MATLAB by editing the `javaclasspath.txt` file (create the file if it does not exist). Run the following in MATLAB Command Window:
     ```MATLAB
     edit(fullfile(prefdir,'javaclasspath.txt'))
     ```
     For example, if the location of the `jar` file is `C:\AutoDRIVE-MathWorks\autodrive_matlab_api\lib\target\WebSocket-1.0.0.jar`, then open the static class path file with the above command and add the full path to it. Make sure that there are no other lines with a `WebSocket-*` entry. You can refer to [MATLAB's Documentation](https://www.mathworks.com/help/matlab/matlab_external/static-path-of-java-class-path.html) for more information on the static Java class path.

     After having done this, **restart MATLAB** and check that the path was read by MATLAB properly by running the `javaclasspath` command. The newly added path should appear at the bottom of the list, before the `DYNAMIC JAVA PATH` entries. Note that seeing the entry here does not mean that MATLAB necessarily found the `jar` file properly. You must make sure that the actual `jar` file is indeed available at this location.
   - **[OPTIONAL]** To build the `jar` file yourself, it is recommended to use [Apache Maven](https://maven.apache.org/download.cgi) (tested with version 3.8.1) with [Java Development Kit](https://www.oracle.com/java/technologies/downloads/?er=221886#java8) (tested with version 8u411). Maven will automatically take care of downloading the [`Java-WebSocket`](https://github.com/TooTallNate/Java-WebSocket) library and neatly package everything into a single file (an "uber jar") based on the [`pom.xml`](autodrive_matlab_api/lib/pom.xml). Once the `mvn` command is on your path, simply `cd` to the `lib` directory and execute the `mvn package` command.
2. Add the `autodrive_matlab_api` directory to MATLAB path by right-clicking on it from MATLAB's file explorer and selecting `Add to Path` &rarr; `Selected Folders and Subfolders`.

## USAGE

1. Execute AutoDRIVE MATLAB API:
    ```MATLAB
    autodrive = example_{vehicle}(4567)
    ```
    Replace `{vehicle}` by one of the available objects (use the URL to download the corresponding vehicle-specific simulator):
    - `roboracer` for [RoboRacer (formerly F1Tenth)](https://github.com/AutoDRIVE-Ecosystem/AutoDRIVE-MathWorks/releases/download/v0.1.0/autodrive_roboracer_simulator.zip)
    - `hunter` for [AgileX Hunter SE](https://github.com/AutoDRIVE-Ecosystem/AutoDRIVE-MathWorks/releases/download/v0.3.0/autodrive_hunter_simulator.zip)
    - `husky` for [Clearpath Husky A200](https://github.com/AutoDRIVE-Ecosystem/AutoDRIVE-MathWorks/releases/download/v0.5.0/autodrive_husky_simulator.zip)
    - `rzr` for [Polaris RZR Pro R 4 Ultimate](https://github.com/AutoDRIVE-Ecosystem/AutoDRIVE-MathWorks/releases/download/v0.7.0/autodrive_rzr_simulator.zip)

2. Terminate AutoDRIVE MATLAB API:
    ```MATLAB
    autodrive.stop
    delete(autodrive)
    clear autodrive
    ```

# Simulink API

<p align="justify">
This section describes the Simulink API for AutoDRIVE, which can be used to develop modular as well as end-to-end autonomous driving algorithms using graphical programming. This API is primarily designed for "system engineers" who prefer an interactive MBD/MBSE toolchain.
</p>

## SETUP

> [!NOTE]
> Please skip this setup if you have already installed the [`autodrive_matlab_api`](autodrive_matlab_api).

1. Install the Java library:
   - Place the [`WebSocket-1.0.0.jar`](autodrive_simulink_api/lib/target/WebSocket-1.0.0.jar) file on the static Java class path in MATLAB by editing the `javaclasspath.txt` file (create the file if it does not exist). Run the following in MATLAB Command Window:
     ```MATLAB
     edit(fullfile(prefdir,'javaclasspath.txt'))
     ```
     For example, if the location of the `jar` file is `C:\AutoDRIVE-MathWorks\autodrive_simulink_api\lib\target\WebSocket-1.0.0.jar`, then open the static class path file with the above command and add the full path to it. Make sure that there are no other lines with a `WebSocket-*` entry. You can refer to [MATLAB's Documentation](https://www.mathworks.com/help/matlab/matlab_external/static-path-of-java-class-path.html) for more information on the static Java class path.

     After having done this, **restart MATLAB** and check that the path was read by MATLAB properly by running the `javaclasspath` command. The newly added path should appear at the bottom of the list, before the `DYNAMIC JAVA PATH` entries. Note that seeing the entry here does not mean that MATLAB necessarily found the `jar` file properly. You must make sure that the actual `jar` file is indeed available at this location.
   - **[OPTIONAL]** To build the `jar` file yourself, it is recommended to use [Apache Maven](https://maven.apache.org/download.cgi) (tested with version 3.8.1) with [Java Development Kit](https://www.oracle.com/java/technologies/downloads/?er=221886#java8) (tested with version 8u411). Maven will automatically take care of downloading the [`Java-WebSocket`](https://github.com/TooTallNate/Java-WebSocket) library and neatly package everything into a single file (an "uber jar") based on the [`pom.xml`](autodrive_simulink_api/lib/pom.xml). Once the `mvn` command is on your path, simply `cd` to the `lib` directory and execute the `mvn package` command.
2. Add the `autodrive_simulink_api` directory to MATLAB path by right-clicking on it from MATLAB's file explorer and selecting `Add to Path` &rarr; `Selected Folders and Subfolders`.

> [!NOTE]
> If you face issues installing/running the AutoDRIVE Simulink API or examples, check out the [Troubleshooting Guide](autodrive_simulink_api/troubleshooting/README.md) for helpful tips.

## USAGE

Run the vehicle-specific `example` file (the first URL) with the corresponding vehicle-specific simulator (the second URL):
- [`example_roboracer.slx`](autodrive_simulink_api/example_roboracer.slx) for [RoboRacer (formerly F1Tenth)](https://github.com/AutoDRIVE-Ecosystem/AutoDRIVE-MathWorks/releases/download/v0.2.0/autodrive_roboracer_simulator.zip)
- [`example_hunter.slx`](autodrive_simulink_api/example_hunter.slx) for [AgileX Hunter SE](https://github.com/AutoDRIVE-Ecosystem/AutoDRIVE-MathWorks/releases/download/v0.4.0/autodrive_hunter_simulator.zip)
- [`example_husky.slx`](autodrive_simulink_api/example_husky.slx) for [Clearpath Husky A200](https://github.com/AutoDRIVE-Ecosystem/AutoDRIVE-MathWorks/releases/download/v0.6.0/autodrive_husky_simulator.zip)
- [`example_rzr.slx`](autodrive_simulink_api/example_rzr.slx) for [Polaris RZR Pro R 4 Ultimate](https://github.com/AutoDRIVE-Ecosystem/AutoDRIVE-MathWorks/releases/download/v0.8.0/autodrive_rzr_simulator.zip)

> [!NOTE]
> The AutoDRIVE Simulink API, which is implemented as a Level-2 MATLAB S-Function, will automatically take care of creating a WebSocket server instance upon running the Simulink model and will ensure a graceful exit upon termination by stopping the server instance, deleting it, and clearing it from the memory.

# Turnkey Demos

<p align="justify">
This section describes various turnkey demos for modular as well as end-to-end autonomous driving algorithms developed using AutoDRIVE Ecosystem and MathWorks tool suite.
</p>

|                   |                    |
|:------------------|:-------------------|
| ![](autodrive_turnkey_demos/autodrive_rzr_aeb_mbd/autodrive_rzr_aeb_mbd.gif) | [**autodrive_rzr_aeb_mbd**](autodrive_turnkey_demos/autodrive_rzr_aeb_mbd)<br>- **Vehicle:** RZR Pro R 4 Ultimate<br>- **Sensors:** Camera + IMU + Encoders<br>- **Environment:** Handcrafted Dirt Road in Thick Vegetation<br>- **Task:** Autonomous Emergency Braking (AEB)<br>- **Approach:** Model-Based Design (MBD) using Simulink<br>- **Simulator:** [autodrive_rzr_simulator.zip](https://github.com/AutoDRIVE-Ecosystem/AutoDRIVE-MathWorks/releases/download/v1.0.0/autodrive_rzr_simulator.zip) |
| ![](autodrive_turnkey_demos/autodrive_rzr_aeb_mbse/autodrive_rzr_aeb_mbse.gif) | [**autodrive_rzr_aeb_mbse**](autodrive_turnkey_demos/autodrive_rzr_aeb_mbse)<br>- **Vehicle:** RZR Pro R 4 Ultimate<br>- **Sensors:** Camera + IMU + Encoders<br>- **Environment:** Handcrafted Dirt Road in Thick Vegetation<br>- **Task:** Autonomous Emergency Braking (AEB)<br>- **Approach:** Model-Based Systems Engineering (MBSE) using System Composer<br>- **Simulator:** [autodrive_rzr_simulator.zip](https://github.com/AutoDRIVE-Ecosystem/AutoDRIVE-MathWorks/releases/download/v1.1.0/autodrive_rzr_simulator.zip)<br>- **Artifacts:** [Research Paper](https://doi.org/10.1016/j.ifacol.2025.12.336), [YouTube Video](https://youtu.be/FsSTWJiiEWg?si=6_EhYzU20gqP7WWY), [MathWorks Handout](https://github.com/AutoDRIVE-Ecosystem/AutoDRIVE-MathWorks/blob/main/media/VIPR-GS%20%2B%20MathWorks%20Autonomous%20Systems%20Case%20Study%201.pdf), [MathWorks Story](https://www.mathworks.com/company/user_stories/scalable-digital-engineering-for-autonomous-vehicle-validation.html) |
| ![](autodrive_turnkey_demos/autodrive_husky_g2g_mbse/autodrive_husky_g2g_mbse.gif) | [**autodrive_husky_g2g_mbse**](autodrive_turnkey_demos/autodrive_husky_g2g_mbse)<br>- **Vehicle:** Husky A200<br>- **Sensors:** GNSS + IMU<br>- **Environment:** Procedurally generated uneven terrain<br>- **Task:** Autonomous Go-to-Goal (G2G) Navigation<br>- **Approach:** Model-Based Systems Engineering (MBSE) using System Composer<br>- **Simulator:** [autodrive_husky_simulator.zip](https://github.com/AutoDRIVE-Ecosystem/AutoDRIVE-MathWorks/releases/download/v2.0.0/autodrive_husky_simulator.zip)<br>- **Artifacts:** [Research Paper](https://doi.org/10.1115/1.4069966), [YouTube Video](https://youtu.be/isLNbC_9I8Q?si=sQ9ouU3EsF4tS-A1), [MathWorks Handout](https://github.com/AutoDRIVE-Ecosystem/AutoDRIVE-MathWorks/blob/main/media/VIPR-GS%20%2B%20MathWorks%20Autonomous%20Systems%20Case%20Study%202.pdf) |
|                    |                     |

**Taxonomy & Nomenclature:**
- `*_alg`: Algorithm Development using [MATLAB](https://www.mathworks.com/products/matlab.html)
- `*_mbd`: Model-Based Design (MBD) using [Simulink](https://www.mathworks.com/products/simulink.html)
- `*_mbse`: Model-Based Systems Engineering (MBSE) using [System Composer](https://www.mathworks.com/products/system-composer.html)
