import Foundation

/// A structure representing a BK-tree that stores perceptual hash values and associated metadata.
/// This tree structure is useful for quickly finding items that have similar perceptual hashes.
public struct SwiftPhashBKTree {
    /// The root node of the BK-tree.
    public var root: BKTreeNode?

    /// Initializes a new, empty BK-tree.
    public init() {}

    /// Inserts a new value and its associated metadata into the BK-tree.
    /// - Parameters:
    ///   - value: The perceptual hash value as a hexadecimal string.
    ///   - metadata: A dictionary containing metadata associated with the hash.
    public mutating func insert(value: String, metadata: [String: Any]) {
        let phash = UInt64(value, radix: 16)!
        if let root = self.root {
            root.insert(newPhash: phash, newMetadata: metadata)
        } else {
            self.root = BKTreeNode(phash: phash, metadata: metadata)
        }
    }
    
    /// Searches the BK-tree for items that are within a specified Hamming distance from a query hash.
    /// - Parameters:
    ///   - query: The query hash as a hexadecimal string.
    ///   - maxDistance: The maximum Hamming distance for matches.
    /// - Returns: An array of tuples, each containing a hash string and its associated metadata arrays.
    public func search(query: String, maxDistance: Int) -> [(String, [[String: Any]])] {
        let phash = UInt64(query, radix: 16)!
        guard let root = self.root else { return [] }
        let results =  root.search(query: phash, maxDistance: maxDistance)
        
        let convertedResults: [(String, [[String: Any]])] = results.map { (phash, metadata) in
            (String(phash, radix: 16, uppercase: true), metadata)
        }
        
        return convertedResults
    }
    
    /// Converts the BK-tree into a JSON object.
    /// - Returns: A dictionary representing the BK-tree in JSON format.
    public func toJSON() -> [String: Any] {
        guard let root = root else { return [:]}
        let json = root.toJSON()
        return json
    }
    
    /// Creates a BK-tree from a JSON object.
    /// - Parameter json: A dictionary representing the BK-tree in JSON format.
    /// - Returns: A `SwiftPhashBKTree` instance initialized from the JSON data.
    public static func fromJSON(json: [String: Any]) -> SwiftPhashBKTree {
        let rootNode = BKTreeNode.fromJSON(json: json)
        print(rootNode!)
        var tree = SwiftPhashBKTree()
        tree.root = rootNode
        return tree
    }
}

public class BKTreeNode {
    var phash: UInt64
    var metadataList: [[String: Any]]
    var children: [Int: BKTreeNode]

    init(phash: UInt64, metadata: [String: Any]) {
        self.phash = phash
        self.metadataList = [metadata]
        self.children = [:]
    }
    
    init(phash: UInt64, metadataList: [[String: Any]]) {
        self.phash = phash
        self.metadataList = metadataList
        self.children = [:]
    }

    static func hammingDistance(from: UInt64, to: UInt64) -> Int {
        let xorResult = from ^ to
        return xorResult.nonzeroBitCount
    }

    func insert(newPhash: UInt64, newMetadata: [String: Any]) {
        let distance = BKTreeNode.hammingDistance(from: self.phash, to: newPhash)
        if distance == 0 {
            self.metadataList.append(newMetadata)
            return
        }
        if let child = children[distance] {
            child.insert(newPhash: newPhash, newMetadata: newMetadata)
        } else {
            children[distance] = BKTreeNode(phash: newPhash, metadata: newMetadata)
        }
    }
    
    func search(query: UInt64, maxDistance: Int) -> [(UInt64, [[String: Any]])] {
        var results: [(UInt64, [[String: Any]])] = []
        let distance = BKTreeNode.hammingDistance(from: self.phash, to: query)
        if distance <= maxDistance {
            results.append((self.phash, self.metadataList))
        }
        // Explore the children nodes that might have a match
        for d in max(0, distance - maxDistance)...(distance + maxDistance) {
            if let child = children[d] {
                results.append(contentsOf: child.search(query: query, maxDistance: maxDistance))
            }
        }
        return results
    }
    
    func toJSON() -> [String: Any] {
        var json = [String: Any]()
        json["phash"] = String(self.phash, radix: 16, uppercase: true)
        json["metadataList"] = self.metadataList
        var childrenJSON = [String: Any]()
        for (distance, child) in children {
            childrenJSON[String(distance)] = child.toJSON()
        }
        json["children"] = childrenJSON
        return json
    }
    
    static func fromJSON(json: [String: Any]) -> BKTreeNode? {
        guard let phashString = json["phash"] as? String, let phash = UInt64(phashString, radix: 16),
              let metadataList = json["metadataList"] as? [[String: Any]] else {
            return nil
        }
        let node = BKTreeNode(phash: phash, metadataList: metadataList)
        if let childrenJSON = json["children"] as? [String: [String: Any]] {
            for (distanceStr, childJSON) in childrenJSON {
                if let distance = Int(distanceStr), let childNode = fromJSON(json: childJSON) {
                    node.children[distance] = childNode
                }
            }
        }
        return node
    }
}
