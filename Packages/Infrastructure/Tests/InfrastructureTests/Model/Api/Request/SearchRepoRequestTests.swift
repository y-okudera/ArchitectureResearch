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
        let sut = SearchRepoRequest(searchQuery: "test", page: 1)
        XCTAssertEqual(sut.path, "/search/repositories")
        XCTAssertEqual(sut.method, "GET")
        XCTAssertEqual(sut.queryItems?[0], .init(name: "q", value: "test"))
        XCTAssertEqual(sut.queryItems?[1], .init(name: "order", value: "desc"))
        XCTAssertEqual(sut.queryItems?[2], .init(name: "per_page", value: "20"))
        XCTAssertEqual(sut.queryItems?[3], .init(name: "page", value: "1"))
    }
}
