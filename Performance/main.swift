//
//  main.swift
//  Performance
//
//  Created by Adrian Bobrowski on 05.08.2017.
//  Copyright © 2017 Adrian Bobrowski (Decybel07), adrian071993@gmail.com. All rights reserved.
//

import Foundation

func random() -> Float {
    return Float(arc4random()) / Float(UINT32_MAX)
}

func randomArray(size: Int) -> [Float] {
    return (0 ..< size).map { _ in random() }
}

func getTime() -> UInt64 {
    return DispatchTime.now().uptimeNanoseconds
}

struct XYPoint {
    let x: Float
    let y: Float
}

func test(size: Int, repetitions: Int = 10) {
    let xArray = randomArray(size: size)
    let yArray = randomArray(size: size)
    
    func pre() {
        var spectrum: [XYPoint] = []
        spectrum = zip(xArray, yArray).map(XYPoint.init)
    }
    
    func testA() -> Double {
        let start = getTime()
        var spectrum: [XYPoint] = []
        
        for i in 0..<xArray.count {
            let xy = XYPoint(x: xArray[i], y: yArray[i])
            spectrum.append(xy)
        }
        let stop = getTime()
        return Double(stop - start) / 1_000_000_000
    }
    
    func testB() -> Double {
        let start = getTime()
        var spectrum: [XYPoint] = []
        spectrum = zip(xArray, yArray).map(XYPoint.init)
        let stop = getTime()
        return Double(stop - start) / 1_000_000_000
    }
    
    func testC() -> Double {
        let start = getTime()
        var spectrum: [XYPoint] = []
        spectrum = (0 ..< xArray.count).map { i in
            return XYPoint(x: xArray[i], y: yArray[i])
        }
        let stop = getTime()
        return Double(stop - start) / 1_000_000_000
    }
    
    func testD() -> Double {
        let start = getTime()
        var spectrum: [XYPoint] = []
        spectrum.reserveCapacity(xArray.count)
        for (index, _) in xArray.enumerated() {
            spectrum.append(XYPoint(x: xArray[index], y: yArray[index]))
        }
        let stop = getTime()
        return Double(stop - start) / 1_000_000_000
    }
    
    var a = 0.0
    var b = 0.0
    var c = 0.0
    var d = 0.0
    
    (0 ..< repetitions).forEach { _ in
        a += testA()
        b += testB()
        c += testC()
        d += testD()
    }
    
    print(String(
        format: "│ %9d ║ %12.9f │ %12.9f │ %12.9f │ %12.9f │",
        size,
        a / Double(repetitions),
        b / Double(repetitions),
        c / Double(repetitions),
        d / Double(repetitions)
    ))
}

print("            ╭──────────────┬──────────────┬──────────────┬──────────────╮")
print("            │       A      │       B      │       C      │       D      │")
print("╭───────────╬══════════════╪══════════════╪══════════════╪══════════════╡")
test(size: 100)
test(size: 200)
test(size: 500)
test(size: 1_000)
test(size: 2_000)
test(size: 5_000)
test(size: 10_000)
test(size: 20_000)
test(size: 50_000)
test(size: 100_000)
test(size: 200_000)
test(size: 500_000)
test(size: 1_000_000)
test(size: 2_000_000)
test(size: 5_000_000)
test(size: 10_000_000)
test(size: 20_000_000)
test(size: 50_000_000)
test(size: 100_000_000)
print("└───────────╨──────────────┴──────────────┴──────────────┴──────────────┘")
