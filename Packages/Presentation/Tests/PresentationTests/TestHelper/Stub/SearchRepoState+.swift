//
//  SearchRepoState+.swift
//  
//
//  Created by Yuki Okudera on 2022/08/17.
//

@testable import Presentation
import XCTest

extension SearchRepoState {
    func verify(isLoading: Bool, page: Int, searchQuery: String, hasNext: Bool, numberOfItems: Int) async {
        XCTAssertEqual(self.isLoading, isLoading)
        XCTAssertEqual(self.page, page)
        XCTAssertEqual(self.searchQuery, searchQuery)
        let hasNextValue = await self.viewData.hasNext
        XCTAssertEqual(hasNextValue, hasNext)
        XCTAssertEqual(self.viewData.numberOfItems, numberOfItems)
    }
}
