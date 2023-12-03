# Swift FileUtils
A Swift package that provides functionality for efficient file operations.

WIP: Documentation, features and names are a work in progress.

## Adding FileUtils as a dependency

To use the FileUtils library in a SwiftPM project, add the following line to the dependencies in your Package.swift file:
```
.package(url: "https://github.com/Optiroc/swift-fileutils", from: "0.1.0"),
```

Include "FileUtils" as a dependency for your target:
```
.target(name: "<target>", dependencies: [
    .product(name: "FileUtils", package: "swift-fileutils"),
]),
```

Finally, add `import FileUtils` to your source code.

## Test data
Large test files are omitted from the repository. To successfully run the tests, get `Apache.log` and `HPC.log` from [here](https://zenodo.org/records/8196385) and place in `Tests/FileUtilsTests/Data`. 

---

created by david lindecrantz and distributed under the terms of the [mit license](./LICENSE).
