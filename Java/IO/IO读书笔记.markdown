# 《java7入门经典》
FileSystems

```java
FileSystem fileSystem = FileSystems.getDefault();
	Iterable<FileStore> stores = fileSystem.getFileStores();
		
	long gigabyte = 1_073_741_824L;
	for(FileStore store : stores) {
		try {
			System.out.format("\nStore: %-20s %5s   Capacity: %5dgb   Unallocated: %6dgb",
					store.name(), 
					store.type(), 
					store.getTotalSpace()/gigabyte, 
					store.getUnallocatedSpace()/gigabyte);
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
```

有用的对象：
FileSystems
Paths
Path
Files
System
BasicFileAttributes
FileTime
