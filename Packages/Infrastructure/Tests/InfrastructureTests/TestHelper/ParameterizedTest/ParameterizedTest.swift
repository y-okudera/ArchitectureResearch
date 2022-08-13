//
//  ParameterizedTest.swift
//  
//
//  Created by Yuki Okudera on 2022/08/13.
//

import XCTest

final class ParameterizedTest<Input, Expect> {
    typealias TestCase = (input: Input, expect: Expect)
    typealias TestingBlock = (TestCase) async -> Void

    private var testCases = [TestCase]()

    init(testCases: [TestCase], expectation: XCTestExpectation) {
        self.testCases = testCases
        expectation.expectedFulfillmentCount = testCases.count
    }

    func runTest(testingBlock: TestingBlock) async {
        for testCase in testCases {
            await testingBlock(testCase)
        }
    }
}
