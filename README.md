# Drake Extension Library
This repository demonstrates how to achieve the following :
1. Using Drake's C++ API and system's framework to make custom/derived objects
2. Minimally binding the derived objects
3. Packaging the extended functionalities as a separate Python Package/Module

The setup used in repository tries to combine the [Drake CMake project example](https://github.com/RobotLocomotion/drake-external-examples/tree/main) with [pybind11's CMake setup](https://github.com/pybind/cmake_example/tree/master) and take the best of two examples.

The resulting implementation looks more straight forward and has additional steps to package and ship the resulting code.

> [!TIP]
> One Cool application of this approach is creating back box systems and shipping it to others as a python package. This is great if you are Teacher/Lecturer and you would like to test your pupils. With this method, the dynamics of a system is obfuscated since it is already complied and your pupils won't be able see what is going on in the system.

If you think the current setup can be improved, please open an issue or a pull request. Contributions and suggestions are appreciated.


## Setup Guide
> [!NOTE]
> The setup has only been tested with Ubuntu 24.04 (Noble) operating system, Python 3.12 and Drake v1.32.0
> If you encountered any issues feel free to leave an issue so we can fix it together.
> You are also welcome to make a PR and extend the support.

### Installing pre-requisites
First, make sure you have all the essential tools installed:


Then we are ready to install Drake by following the official installation procedure.
> [!IMPORTANT]
> We just need the  pre-compiled binaries as APT packages (*.deb)  installation of Drake and we don't need to use pip to install pydrake.

Finally we need to install `pybind11` simply by:


### Compilation, Packaging and Testing
The whole process is made simple by just invoking this command at the root of the project:

```
pip3 install .
```

`setuptool` and CMake magic will kick in and start the C++ compilation, python binding and packaging.


In order to make sure the process was fully successful, you can use `pytest` to run the package test:
```
py.test
```

## TODOs
- [ ] Add a Dockerfile for more reproducibility and transparency of the setup
- [ ] Add information about how to shared the packaged python wheel.
- [ ] Clean up of the generic CMake file and pyproject.
- [ ] Try binding whole diagrams and objects in Drake.


## References
1. [Drake's official examples repo](https://github.com/RobotLocomotion/drake-external-examples/tree/main)
2. [PyBind11's official example repo for CMake projects](https://github.com/pybind/cmake_example/tree/master)
