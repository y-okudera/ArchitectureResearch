//
//  LoadMoreRepoUseCaseTests.swift
//
//
//  Created by okudera on 2022/09/16.
//

@testable import Domain
import XCTest

final class LoadMoreRepoUseCaseTests: XCTestCase {

    func testExecute() async throws {
        // Setup
        let searchedRepoRepositoryMock = SearchedRepoRepositoryMock()
        searchedRepoRepositoryMock.readSearchRepoRequestDataHandler = {
            SearchRepoRequestData(searchQuery: "test", page: 1, hasNext: false)
        }
        searchedRepoRepositoryMock.searchHandler = { _, _ in
            SearchedRepo(
                items: .stub,
                searchRepoRequestData: SearchRepoRequestData(searchQuery: "test", page: 1, hasNext: false)
            )
        }
        let loadMoreRepoInteractor = LoadMoreRepoInteractor(searchedRepoRepository: searchedRepoRepositoryMock)
        // Exercise
        let result = try await loadMoreRepoInteractor.execute()

        // Verify
        XCTAssertEqual(searchedRepoRepositoryMock.searchCallCount, 1)
        XCTAssertEqual(searchedRepoRepositoryMock.searchArgValues[0].0, "test")
        XCTAssertEqual(searchedRepoRepositoryMock.searchArgValues[0].1, 2)
        XCTAssertEqual(result.searchRepoRequestData.hasNext, false)
        result.items.verifyEqualToStub()
    }
}
