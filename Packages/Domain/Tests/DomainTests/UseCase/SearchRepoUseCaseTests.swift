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
        let gitHubRepoRepositoryMock = GitHubRepoRepositoryMock()
        gitHubRepoRepositoryMock.searchHandler = { _, _ in
            (hasNext: true, items: .stub)
        }
        let searchRepoUseCaseImpl = SearchRepoUseCaseImpl(gitHubRepoRepository: gitHubRepoRepositoryMock)

        // Exercise
        let result = try await searchRepoUseCaseImpl.execute(searchQuery: "test", page: 1)

        // Verify
        XCTAssertEqual(gitHubRepoRepositoryMock.searchCallCount, 1)
        XCTAssertEqual(gitHubRepoRepositoryMock.searchArgValues[0].0, "test")
        XCTAssertEqual(gitHubRepoRepositoryMock.searchArgValues[0].1, 1)
        XCTAssertEqual(result.numberOfItems, 1)
        let hasNext = await result.hasNext
        XCTAssertEqual(hasNext, true)
        let items = await result.items
        items.verifyEqualToStub()
    }
}
