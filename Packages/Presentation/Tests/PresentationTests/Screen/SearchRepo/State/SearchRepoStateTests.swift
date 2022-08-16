//
//  SearchRepoStateTests.swift
//  
//
//  Created by Yuki Okudera on 2022/08/14.
//

@testable import Presentation
import XCTest

final class SearchRepoStateTests: XCTestCase {

    func testInit() async {
        let searchRepoState = SearchRepoState(
            isLoading: false,
            page: 1,
            searchQuery: "",
            viewData: .init(hasNext: true, items: [])
        )

        let isLoading = await searchRepoState.isLoading
        XCTAssertEqual(isLoading, false)
        let page = await searchRepoState.page
        XCTAssertEqual(page, 1)
        let searchQuery = await searchRepoState.searchQuery
        XCTAssertEqual(searchQuery, "")
        let hasNext = await searchRepoState.viewData.hasNext
        XCTAssertEqual(hasNext, true)
        XCTAssertEqual(searchRepoState.viewData.numberOfItems, 0)
    }
}

extension SearchRepoStateTests {

    func testUpdateIsLoading() async {
        let searchRepoState = SearchRepoState(
            isLoading: false,
            page: 1,
            searchQuery: "",
            viewData: .init(hasNext: true, items: [])
        )

        await searchRepoState.update(isLoading: true)
        let isLoading = await searchRepoState.isLoading
        XCTAssertEqual(isLoading, true)
    }
}

extension SearchRepoStateTests {

    func testIsEnabledSearchWhenIsLoading() async {
        let searchRepoState = SearchRepoState(
            isLoading: true,
            page: 1,
            searchQuery: "",
            viewData: .init(hasNext: true, items: [])
        )

        let isEnabledSearch = await searchRepoState.isEnabledSearch(searchQuery: "test")
        XCTAssertEqual(isEnabledSearch, false)
    }

    func testIsEnabledSearchWhenSearchQueryIsEmpty() async {
        let searchRepoState = SearchRepoState(
            isLoading: false,
            page: 1,
            searchQuery: "",
            viewData: .init(hasNext: true, items: [])
        )

        let isEnabledSearch = await searchRepoState.isEnabledSearch(searchQuery: "")
        XCTAssertEqual(isEnabledSearch, false)
    }

    func testIsEnabledSearchWhenSearchQueryIsNil() async {
        let searchRepoState = SearchRepoState(
            isLoading: false,
            page: 1,
            searchQuery: "",
            viewData: .init(hasNext: true, items: [])
        )

        let isEnabledSearch = await searchRepoState.isEnabledSearch(searchQuery: nil)
        XCTAssertEqual(isEnabledSearch, false)
    }

    func testIsEnabledSearch() async {
        let searchRepoState = SearchRepoState(
            isLoading: false,
            page: 1,
            searchQuery: "",
            viewData: .init(hasNext: true, items: [])
        )

        let isEnabledSearch = await searchRepoState.isEnabledSearch(searchQuery: "test")
        XCTAssertEqual(isEnabledSearch, true)
    }
}

extension SearchRepoStateTests {

    func testIsEnabledLoadMoreWhenIsLoading() async {
        let searchRepoState = SearchRepoState(
            isLoading: true,
            page: 1,
            searchQuery: "",
            viewData: .init(hasNext: true, items: [])
        )

        let isEnabledLoadMore = await searchRepoState.isEnabledLoadMore()
        XCTAssertEqual(isEnabledLoadMore, false)
    }

    func testIsEnabledLoadMoreWhenSearchQueryIsEmpty() async {
        let searchRepoState = SearchRepoState(
            isLoading: false,
            page: 1,
            searchQuery: "",
            viewData: .init(hasNext: true, items: [])
        )

        let isEnabledLoadMore = await searchRepoState.isEnabledLoadMore()
        XCTAssertEqual(isEnabledLoadMore, false)
    }

    func testIsEnabledLoadMoreWhenItemsIsEmpty() async {
        let searchRepoState = SearchRepoState(
            isLoading: false,
            page: 1,
            searchQuery: "test",
            viewData: .init(hasNext: true, items: [])
        )

        let isEnabledLoadMore = await searchRepoState.isEnabledLoadMore()
        XCTAssertEqual(isEnabledLoadMore, false)
    }

    func testIsEnabledLoadMoreWhenHasNotNext() async {
        let searchRepoState = SearchRepoState(
            isLoading: false,
            page: 1,
            searchQuery: "test",
            viewData: .init(hasNext: false, items: .stub)
        )

        let isEnabledLoadMore = await searchRepoState.isEnabledLoadMore()
        XCTAssertEqual(isEnabledLoadMore, false)
    }

    func testIsEnabledLoadMore() async {
        let searchRepoState = SearchRepoState(
            isLoading: false,
            page: 1,
            searchQuery: "test",
            viewData: .init(hasNext: true, items: .stub)
        )

        let isEnabledLoadMore = await searchRepoState.isEnabledLoadMore()
        XCTAssertEqual(isEnabledLoadMore, true)
    }
}
