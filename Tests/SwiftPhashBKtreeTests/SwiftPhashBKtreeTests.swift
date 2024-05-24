import XCTest
@testable import SwiftPhashBKtree

final class SwiftPhashBKtreeTests: XCTestCase {
    
    func testBKtree() {
        let fullRange: [UInt64] = Array(1...1000000)

        // Shuffle the array
        let shuffled = fullRange.shuffled()

        // Take the first 10,000 elements
        let selectedNumbers = Array(shuffled.prefix(100))
        
        let phashArray: [UInt64] = selectedNumbers.map { phash in UInt64(phash) }
        
        let hexPhashArray: [String] = phashArray.map { phash in
            String(phash, radix: 16, uppercase: true)
        }
        
        var swiftPhashBKTree = SwiftPhashBKTree()
        
        for (index, hexPhash) in hexPhashArray.enumerated() {
            swiftPhashBKTree.insert(value: hexPhash, metadata: [String(index): "test", String(index+1): "test"])
        }
        
        let astronaut_L = "034933b2ea9cb933"
        let astronaut_M = "434933b2ea9cb932"
        swiftPhashBKTree.insert(value: astronaut_L, metadata: [astronaut_L : "astronaut_L"])
        swiftPhashBKTree.insert(value: astronaut_M, metadata: [astronaut_M : "astronaut_M"])
        swiftPhashBKTree.insert(value: astronaut_M, metadata: [astronaut_M : "astronaut_M2"])
        let Lenna = "98632bb4aec46569"
        let Pepper = "c4fd3e08e388039b"
        swiftPhashBKTree.insert(value: Lenna, metadata: [Lenna : "Lenna"])
        swiftPhashBKTree.insert(value: Pepper, metadata: [Pepper : "Pepper"])
        

        let results = swiftPhashBKTree.search(query: astronaut_M, maxDistance: 2)
        print(results)
        
        print(swiftPhashBKTree.findDuplicates())
        
        let testJson = ["metadataList": [["0": "test", "1": "test"]], "phash": "96C87", "children": ["11": ["metadataList": [["2": "test", "3": "test"]], "phash": "E22ED", "children": ["8": ["children": [:], "metadataList": [["7": "test", "6": "test"]], "phash": "42B35"]]], "8": ["metadataList": [["1": "test", "2": "test"]], "phash": "53695", "children": [:]], "7": ["metadataList": [["5": "test", "6": "test"]], "phash": "B6A42", "children": [:]], "12": ["phash": "79844", "children": [:], "metadataList": [["10": "test", "9": "test"]]], "32": ["children": [:], "metadataList": [["c4fd3e08e388039b": "Pepper"]], "phash": "C4FD3E08E388039B"], "6": ["children": [:], "phash": "1440D", "metadataList": [["8": "test", "9": "test"]]], "9": ["children": ["10": ["children": [:], "metadataList": [["7": "test", "8": "test"]], "phash": "9AB35"]], "metadataList": [["5": "test", "4": "test"]], "phash": "43C3F"], "33": ["phash": "98632BB4AEC46569", "children": [:], "metadataList": [["98632bb4aec46569": "Lenna"]]], "31": ["children": [:], "phash": "34933B2EA9CB933", "metadataList": [["034933b2ea9cb933": "astronaut_L"]]], "13": ["metadataList": [["3": "test", "4": "test"]], "children": [:], "phash": "6819E"]]] as [String : Any]
        
        let swiftPhashBKTree1 = SwiftPhashBKTree.fromJSON(json: testJson)
        let results1 = swiftPhashBKTree1.search(query: astronaut_M, maxDistance: 2)
        print(results1)
    }
}
