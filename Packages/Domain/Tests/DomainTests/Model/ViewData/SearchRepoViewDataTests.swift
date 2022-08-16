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
        let searchRepoViewData = SearchRepoViewData(hasNext: true, items: .stub)

        XCTAssertEqual(searchRepoViewData.numberOfItems, 1)
        let hasNext = await searchRepoViewData.hasNext
        XCTAssertEqual(hasNext, true)
        let items = await searchRepoViewData.items
        XCTAssertEqual(items, .stub)
    }
}
