//
//  SearchRepoStateTests.swift
//
//
//  Created by Yuki Okudera on 2022/08/14.
//

@testable import Presentation
import XCTest

// MARK: - SearchRepoStateTests
final class SearchRepoStateTests: XCTestCase {

    var searchRepoState: SearchRepoState!

    override func setUp() {
        searchRepoState = SearchRepoState(
            isLoading: false,
            page: 1,
            searchQuery: "",
            hasNext: true
        )
    }

    func testInit() async {
        await searchRepoState.verify(isLoading: false, page: 1, searchQuery: "", hasNext: true)
    }
}

extension SearchRepoStateTests {

    func testUpdateIsLoading() async {
        await searchRepoState.update(isLoading: true)
        let isLoading = await searchRepoState.isLoading
        XCTAssertEqual(isLoading, true)
    }
}

extension SearchRepoStateTests {

    func testIsEnabledSearchWhenIsLoading() async {
        searchRepoState = SearchRepoState(
            isLoading: true,
            page: 1,
            searchQuery: "",
            hasNext: true
        )

        let isEnabledSearch = await searchRepoState.isEnabledSearch(searchQuery: "test")
        XCTAssertEqual(isEnabledSearch, false)
    }

    func testIsEnabledSearchWhenSearchQueryIsEmpty() async {
        let isEnabledSearch = await searchRepoState.isEnabledSearch(searchQuery: "")
        XCTAssertEqual(isEnabledSearch, false)
    }

    func testIsEnabledSearchWhenSearchQueryIsNil() async {
        let isEnabledSearch = await searchRepoState.isEnabledSearch(searchQuery: nil)
        XCTAssertEqual(isEnabledSearch, false)
    }

    func testIsEnabledSearch() async {
        let isEnabledSearch = await searchRepoState.isEnabledSearch(searchQuery: "test")
        XCTAssertEqual(isEnabledSearch, true)
    }
}

extension SearchRepoStateTests {

    func testIsEnabledLoadMoreWhenIsLoading() async {
        searchRepoState = SearchRepoState(
            isLoading: true,
            page: 1,
            searchQuery: "",
            hasNext: true
        )

        let isEnabledLoadMore = await searchRepoState.isEnabledLoadMore()
        XCTAssertEqual(isEnabledLoadMore, false)
    }

    func testIsEnabledLoadMoreWhenSearchQueryIsEmpty() async {
        let isEnabledLoadMore = await searchRepoState.isEnabledLoadMore()
        XCTAssertEqual(isEnabledLoadMore, false)
    }

    func testIsEnabledLoadMoreWhenHasNotNext() async {
        searchRepoState = SearchRepoState(
            isLoading: false,
            page: 1,
            searchQuery: "test",
            hasNext: false
        )

        let isEnabledLoadMore = await searchRepoState.isEnabledLoadMore()
        XCTAssertEqual(isEnabledLoadMore, false)
    }

    func testIsEnabledLoadMore() async {
        searchRepoState = SearchRepoState(
            isLoading: false,
            page: 1,
            searchQuery: "test",
            hasNext: true
        )

        let isEnabledLoadMore = await searchRepoState.isEnabledLoadMore()
        XCTAssertEqual(isEnabledLoadMore, true)
    }
}
