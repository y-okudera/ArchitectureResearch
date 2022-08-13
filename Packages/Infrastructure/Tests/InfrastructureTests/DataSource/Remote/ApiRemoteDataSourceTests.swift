//
//  ApiRemoteDataSourceTests.swift
//  
//
//  Created by Yuki Okudera on 2022/08/13.
//

@testable import Infrastructure
import XCTest

final class ApiRemoteDataSourceTests: XCTestCase {

    /// API request test.
    ///
    /// Expectation: Successful API request.
    /// - 200 OK
    /// - 299 Unknown Code
    func testSendRequestWhenReturnedSuccess() async {
        let expectation = XCTestExpectation(description: "Successful API request.")

        typealias Input = (line: UInt, statusCode: Int, sleep: Int)
        typealias Expect = (code: Int, description: String)

        let paramTest = ParameterizedTest<Input, Expect>(
            testCases: [
                (input: (line: #line, statusCode: 200, sleep: 100), expect: (code: 200, description: "OK")),
                (input: (line: #line, statusCode: 299, sleep: 100), expect: (code: 299, description: "299 Unknown Code")),
            ],
            expectation: expectation
        )

        await paramTest.runTest { testCase in
            // Setup
            let dummyRequest = DummyRequest(statusCode: testCase.input.statusCode, sleep: testCase.input.sleep)

            do {
                // Exercise SUT
                let result = try await ApiRemoteDataSourceImpl(urlSession: .shared).sendRequest(dummyRequest)

                // Verify
                XCTAssertEqual(result.response.code, testCase.expect.code, line: testCase.input.line)
                XCTAssertEqual(result.response.description, testCase.expect.description, line: testCase.input.line)
                expectation.fulfill()
            } catch {
                XCTFail("Unexpected case.")
            }
        }
        wait(for: [expectation], timeout: 1.0)
    }

    /// API request test.
    ///
    /// Expectation: API request timed out.
    func testSendRequestWhenTimedOut() async {
        let expectation = XCTestExpectation(description: "API request timed out.")

        typealias Input = (line: UInt, statusCode: Int, sleep: Int)
        typealias Expect = (code: Int, description: String)

        let paramTest = ParameterizedTest<Input, Expect>(
            testCases: [
                (input: (line: #line, statusCode: 200, sleep: 2_000), expect: (code: 200, description: "OK")),
            ],
            expectation: expectation
        )

        await paramTest.runTest { testCase in
            // Setup
            let dummyRequest = DummyRequest(statusCode: testCase.input.statusCode, sleep: testCase.input.sleep)

            do {
                // Exercise SUT
                _ = try await ApiRemoteDataSourceImpl(urlSession: .shared).sendRequest(dummyRequest)
            } catch {
                // Verify
                XCTAssertEqual((error as NSError).domain, "Infrastructure.ApiError", line: testCase.input.line)
                XCTAssertEqual((error as NSError).code, 0, line: testCase.input.line)
                expectation.fulfill()
            }
        }
        wait(for: [expectation], timeout: 3.0)
    }
}
