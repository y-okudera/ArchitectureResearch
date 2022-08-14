//
//  SearchRepoRequestTests.swift
//  
//
//  Created by Yuki Okudera on 2022/08/13.
//

@testable import Infrastructure
import XCTest

final class SearchRepoRequestTests: XCTestCase {

    func testInit() {
        let searchRepoRequest = SearchRepoRequest(searchQuery: "test", page: 1)
        XCTAssertEqual(searchRepoRequest.path, "/search/repositories")
        XCTAssertEqual(searchRepoRequest.method, "GET")
        XCTAssertEqual(searchRepoRequest.queryItems?[0], .init(name: "q", value: "test"))
        XCTAssertEqual(searchRepoRequest.queryItems?[1], .init(name: "order", value: "desc"))
        XCTAssertEqual(searchRepoRequest.queryItems?[2], .init(name: "per_page", value: "20"))
        XCTAssertEqual(searchRepoRequest.queryItems?[3], .init(name: "page", value: "1"))
    }
}
