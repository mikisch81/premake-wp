# premake-wp
Premake extension which enables to build WindowsPhone projects for Visual Studio (vs2013 and vs2015 only!)

### Usage ###

Simply add:
```lua
architecture "ARM"
```
or
```lua
architecture "ARM64"
```
to a C/C++ solution/project.

The output will be a C/C++ executable/library which targets WindowsPhone devices.

### Example ###

The contents of your premake5.lua file would be:

```lua
solution "MySolution"
    configurations { "release", "debug" }
    
    project "MyWpProject"
        kind "ConsoleApp"
        language "C++"
        architecture "ARM"
        exceptionhandling ("On")
        files { "hello.cpp" }
```