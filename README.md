# SwiftPhashBKtree
Swift implementation of the Burkhard-Keller Tree (BK-tree), optimized for retrieval of perceptual hashes (pHash) along with associated metadata

## Requirements

- iOS 16.0+
- Swift 5.3+
- Xcode 12.0+

## Installation

### Swift Package Manager

You can install `SwiftPhashBKtree` using the Swift Package Manager by adding the following dependency to your `Package.swift` file:

```swift
dependencies: [
    .package(url: "https://github.com/TokyoWolFrog/SwiftPhashBKtree.git", from: "0.1.0")
]
```

Then, simply add SwiftPhashBKtree to your target dependencies:

```swift
targets: [
    .target(
        name: "YourTarget",
        dependencies: ["SwiftPhashBKtree"]),
]
```

## Usage

### Creating a Tree

You can start by creating an instance of SwiftPhashBKTree and inserting items with their associated metadata.

```swift
import SwiftPhashBKTree

var bkTree = SwiftPhashBKTree()

// Insert items into the BK-tree
bkTree.insert(value: "bcb2aff0", metadata: ["name": "Image1"])
bkTree.insert(value: "bcb2aef1", metadata: ["name": "Image2"])
```

### Searching

To search for items similar to a given perceptual hash within a specified distance:

```swift
let results = bkTree.search(query: "bcb2aff0", maxDistance: 2)

for (hash, metadata) in results {
    print("Found hash: \(hash) with metadata: \(metadata)")
}
```

### Serialization and Deserialization

You can serialize the BK-tree to JSON for storage or network transmission and To recreate a BK-tree from JSON:

```swift
let json = bkTree.toJSON()
print(json)
let bkTree = SwiftPhashBKTree.fromJSON(json: json)
```
