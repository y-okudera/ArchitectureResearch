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
        searchedRepoRepositoryMock.readSearchRepoDataHandler = {
            SearchRepoData.shared.update(searchQuery: "test", page: 1, hasNext: false)
            return SearchRepoData.shared
        }
        searchedRepoRepositoryMock.searchHandler = { _, _ in
            SearchedRepo(
                items: .stub,
                searchQuery: SearchRepoData.shared.searchQuery ?? "",
                page: SearchRepoData.shared.page,
                hasNext: SearchRepoData.shared.hasNext
            )
        }
        let loadMoreRepoInteractor = LoadMoreRepoInteractor(searchedRepoRepository: searchedRepoRepositoryMock)
        // Exercise
        let result = try await loadMoreRepoInteractor.execute()

        // Verify
        XCTAssertEqual(searchedRepoRepositoryMock.searchCallCount, 1)
        XCTAssertEqual(searchedRepoRepositoryMock.searchArgValues[0].0, "test")
        XCTAssertEqual(searchedRepoRepositoryMock.searchArgValues[0].1, 2)
        XCTAssertEqual(result.searchRepoData.hasNext, false)
        result.items.verifyEqualToStub()
    }
}
