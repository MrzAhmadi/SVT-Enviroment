# Systems Verification & Testing Environment

This is a Dockerized environment for the **Systems Verification & Testing** course. It includes a pre-configured setup with **Siemens EDA tools (vsim)** and **HARM** (Hint-based AsseRtion Miner).

## Prerequisites
* **Docker** installed on your machine.
* A valid **EDA tools license** and installation directory (configured in `run.sh`).

## Quick Start

### 1. Build the Environment
Create the Docker image by running:

```bash
./build.sh
```
(Note: This downloads Ubuntu 22.04, CMake 3.30, and compiles HARM from source. It may take a few minutes.)

2. Run the Container
Start the interactive shell with X11 forwarding (for GUI support):

```bash
./run.sh
```

Usage
Once inside the container:

HARM is available directly in your PATH. Run harm --help to verify.

ModelSim/Questa (vsim) is configured at /opt/eda. Run vsim to launch.

Your current local directory is mounted to /home/user inside the container.

Troubleshooting
Permission Denied: Run chmod +x build.sh run.sh to make the scripts executable.

Tools Missing: Ensure the path to your local EDA installation in run.sh is correct.