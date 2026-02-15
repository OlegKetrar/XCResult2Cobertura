
## TODO:

1) get `changed` files as a parameter

2) get xcresult `report` as a parameter

3) convert `report.xcresult` to json
```bash
xcrun xcov view --report --json report.xcresult
```

4) get list of executed `files` from `report`
```bash
xcrun xcov view --archive --file-list report.xcresult
```

5) get lines information for every changed file if it exist in executed file list
```bash
xcrun xcov view --archive --file <file> --json report.xcresult
```

6) group resulting files by directories
```bash

$ the file list:
- dir1/dir2/file1.swift
- dir1/file2.swift
- dir1/file3.swift
- dir1/dir3/file4.swift

# should produce package list:
- dir1.dir2
- dir1
- dir1.dir3
```
7) Generate Cobertura XML file
