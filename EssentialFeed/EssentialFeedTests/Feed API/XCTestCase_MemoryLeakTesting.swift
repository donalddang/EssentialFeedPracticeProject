//
//  XCTestCase_MemoryLeakTesting.swift
//  EssentialFeed
//
//  Created by Donald Dang on 1/21/25.
//

import XCTest

extension XCTestCase {
    func trackForMemoryLeaks(_ instance: AnyObject, file: StaticString = #file, line: UInt = #line) {
        addTeardownBlock { [weak instance] in
            XCTAssertNil(instance, "Instance should've been deallocated. Potential Memory leak", file: file, line: line)
        }
    }
}
