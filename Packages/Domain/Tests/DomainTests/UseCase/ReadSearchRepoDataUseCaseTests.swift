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
        searchedRepoRepositoryMock.readSearchRepoRequestDataHandler = {
            SearchRepoRequestData(searchQuery: "test", page: 1, hasNext: false)
        }
        let readSearchRepoDataInteractor = ReadSearchRepoRequestDataInteractor(searchedRepoRepository: searchedRepoRepositoryMock)
        // Exercise
        let result = readSearchRepoDataInteractor.execute()

        // Verify
        XCTAssertEqual(searchedRepoRepositoryMock.readSearchRepoRequestDataCallCount, 1)
        XCTAssertEqual(result, searchedRepoRepositoryMock.readSearchRepoRequestData())
    }
}
