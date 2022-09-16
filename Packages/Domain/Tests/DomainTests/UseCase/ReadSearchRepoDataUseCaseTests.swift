//
//  ReadSearchRepoDataUseCaseTests.swift
//  
//
//  Created by okudera on 2022/09/16.
//

@testable import Domain
import XCTest

final class ReadSearchRepoDataUseCaseTests: XCTestCase {

    func testExecute() async throws {
        // Setup
        let searchedRepoRepositoryMock = SearchedRepoRepositoryMock()
        searchedRepoRepositoryMock.readSearchRepoDataHandler = {
            SearchRepoData.shared.update(searchQuery: "test", page: 1, hasNext: false)
            return SearchRepoData.shared
        }
        let readSearchRepoDataInteractor = ReadSearchRepoDataInteractor(searchedRepoRepository: searchedRepoRepositoryMock)
        // Exercise
        let result = readSearchRepoDataInteractor.execute()

        // Verify
        XCTAssertEqual(searchedRepoRepositoryMock.readSearchRepoDataCallCount, 1)
        XCTAssertEqual(result, searchedRepoRepositoryMock.readSearchRepoData())
    }
}
