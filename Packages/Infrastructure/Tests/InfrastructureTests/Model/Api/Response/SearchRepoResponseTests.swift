//
//  SearchRepoResponseTests.swift
//  
//
//  Created by Yuki Okudera on 2022/08/13.
//

@testable import Infrastructure
import XCTest

final class SearchRepoResponseTests: XCTestCase {

    func testInit() throws {
        let searchRepoResponse = SearchRepoResponse.stub
        XCTAssertEqual(searchRepoResponse.items.count, 1)
        XCTAssertEqual(searchRepoResponse.items[0].id, 44838949)
        XCTAssertEqual(searchRepoResponse.items[0].fullName, "apple/swift")
        XCTAssertEqual(searchRepoResponse.items[0].description, "The Swift Programming Language")
        XCTAssertEqual(searchRepoResponse.items[0].stargazersCount, 60306)
        XCTAssertEqual(searchRepoResponse.items[0].language, "C++")
        XCTAssertEqual(searchRepoResponse.items[0].htmlUrl, URL(string: "https://github.com/apple/swift")!)
        XCTAssertEqual(searchRepoResponse.items[0].owner.id, 10639145)
        XCTAssertEqual(searchRepoResponse.items[0].owner.login, "apple")
        XCTAssertEqual(searchRepoResponse.items[0].owner.avatarUrl, URL(string: "https://avatars.githubusercontent.com/u/10639145?v=4")!)
        XCTAssertEqual(searchRepoResponse.items[0].owner.htmlUrl, URL(string: "https://github.com/apple")!)
        XCTAssertEqual(searchRepoResponse.items[0].owner.type, "Organization")
    }
}
