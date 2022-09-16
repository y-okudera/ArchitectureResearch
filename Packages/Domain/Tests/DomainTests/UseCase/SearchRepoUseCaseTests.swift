//
//  SearchRepoUseCaseTests.swift
//
//
//  Created by Yuki Okudera on 2022/08/17.
//

@testable import Domain
import XCTest

final class SearchRepoUseCaseTests: XCTestCase {

    func testExecute() async throws {
        // Setup
        let searchedRepoRepositoryMock = SearchedRepoRepositoryMock()
        searchedRepoRepositoryMock.searchHandler = { _, _ in
            SearchedRepo(items: .stub, searchQuery: "test", page: 1, hasNext: true)
        }
        let searchRepoInteractor = SearchRepoInteractor(searchedRepoRepository: searchedRepoRepositoryMock)

        // Exercise
        let result = try await searchRepoInteractor.execute(searchQuery: "test")

        // Verify
        XCTAssertEqual(searchedRepoRepositoryMock.searchCallCount, 1)
        XCTAssertEqual(searchedRepoRepositoryMock.searchArgValues[0].0, "test")
        XCTAssertEqual(searchedRepoRepositoryMock.searchArgValues[0].1, 1)
        XCTAssertEqual(result.searchRepoData.hasNext, true)
        result.items.verifyEqualToStub()
    }
}
