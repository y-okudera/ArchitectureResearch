//
//  SearchRepoViewDataTests.swift
//  
//
//  Created by Yuki Okudera on 2022/08/14.
//

@testable import Domain
import XCTest

final class SearchRepoViewDataTests: XCTestCase {

    func testInit() async {
        let searchRepoViewData = SearchRepoViewData(
            hasNext: true,
            items: [
                .init(
                    id: 44838949,
                    fullName: "apple/swift",
                    description: "The Swift Programming Language",
                    stargazersCount: 60306,
                    language: "C++",
                    htmlUrl: URL(string: "https://github.com/apple/swift")!,
                    owner: .init(
                        id: 10639145,
                        login: "apple",
                        avatarUrl: URL(string: "https://avatars.githubusercontent.com/u/10639145?v=4")!,
                        htmlUrl: URL(string: "https://github.com/apple")!,
                        type: "Organization"
                    )
                )
            ]
        )

        XCTAssertEqual(searchRepoViewData.numberOfItems, 1)
        let hasNext = await searchRepoViewData.hasNext
        XCTAssertEqual(hasNext, true)
        let firstItem = await searchRepoViewData.items[0]
        XCTAssertEqual(firstItem.id, 44838949)
        XCTAssertEqual(firstItem.fullName, "apple/swift")
        XCTAssertEqual(firstItem.description, "The Swift Programming Language")
        XCTAssertEqual(firstItem.stargazersCount, 60306)
        XCTAssertEqual(firstItem.language, "C++")
        XCTAssertEqual(firstItem.htmlUrl, URL(string: "https://github.com/apple/swift")!)
        XCTAssertEqual(firstItem.owner.id, 10639145)
        XCTAssertEqual(firstItem.owner.login, "apple")
        XCTAssertEqual(firstItem.owner.avatarUrl, URL(string: "https://avatars.githubusercontent.com/u/10639145?v=4")!)
        XCTAssertEqual(firstItem.owner.htmlUrl, URL(string: "https://github.com/apple")!)
        XCTAssertEqual(firstItem.owner.type, "Organization")
    }
}
