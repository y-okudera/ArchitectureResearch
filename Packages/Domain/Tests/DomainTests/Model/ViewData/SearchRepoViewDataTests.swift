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

        let hasNext = await searchRepoViewData.hasNext
        XCTAssertEqual(hasNext, true)
        let items = await searchRepoViewData.items
        items.verifyEqualToStub()
    }
}
