//
//  DirectionsTest.swift
//  atcTests
//
//  Created by Vincent Fumo on 9/17/20.
//  Copyright © 2020 Vincent Fumo. All rights reserved.
//

import XCTest
@testable import atc

class DirectionsTest: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDistanceShouldWork() throws {
        XCTAssertEqual(Direction.NW.distance(to: Direction.N), 1)
        XCTAssertEqual(Direction.NW.distance(to: Direction.NE), 2)
        XCTAssertEqual(Direction.NW.distance(to: Direction.E), 3)
        XCTAssertEqual(Direction.N.distance(to: Direction.NE), 1)
        XCTAssertEqual(Direction.N.distance(to: Direction.NW), 7)
    }
    
    func testDistanceCounterShouldWork() throws {
        XCTAssertEqual(Direction.NW.distanceCounter(to: Direction.N), 7)
        XCTAssertEqual(Direction.NW.distanceCounter(to: Direction.NE), 6)
        XCTAssertEqual(Direction.NW.distanceCounter(to: Direction.E), 5)
        XCTAssertEqual(Direction.NE.distanceCounter(to: Direction.N), 1)
        XCTAssertEqual(Direction.NE.distanceCounter(to: Direction.NW), 2)
    }

    func testAddShouldWork() throws {
        XCTAssertEqual(Direction.NW.add(), Direction.N)
        XCTAssertEqual(Direction.N.add(), Direction.NE)
        XCTAssertEqual(Direction.S.add(), Direction.SW)
    }
    
    func testAddTimesShouldWork() throws {
        XCTAssertEqual(Direction.W.add(times: 2), Direction.N)
        XCTAssertEqual(Direction.NW.add(times: 2), Direction.NE)
        
        XCTAssertEqual(Direction.N.add(times: 8), Direction.N)
        XCTAssertEqual(Direction.N.add(times: 9), Direction.NE)
        XCTAssertEqual(Direction.N.add(times: 17), Direction.NE)
    }
    
    func testSubShouldWork() throws {
        XCTAssertEqual(Direction.N.sub(), Direction.NW)
        XCTAssertEqual(Direction.NW.sub(), Direction.W)
        XCTAssertEqual(Direction.NE.sub(), Direction.N)
        XCTAssertEqual(Direction.W.sub(), Direction.SW)
    }

    func testSubTimesShouldWork() throws {
        XCTAssertEqual(Direction.W.sub(times: 2), Direction.S)
        XCTAssertEqual(Direction.NW.sub(times: 2), Direction.SW)

        XCTAssertEqual(Direction.N.sub(times: 8), Direction.N)
        XCTAssertEqual(Direction.N.sub(times: 9), Direction.NW)
        XCTAssertEqual(Direction.N.sub(times: 17), Direction.NW)
    }
}
