//
//  GitHubRepoRepositoryImplTests.swift
//
//
//  Created by Yuki Okudera on 2022/08/14.
//

@testable import Infrastructure
import Domain
import XCTest

final class GitHubRepoRepositoryImplTests: XCTestCase {

    func testSearch() async throws {
        // Setup
        let searchRepoDataSourceMock = SearchRepoDataSourceMock()
        searchRepoDataSourceMock.requestHandler = { _, _ in
            let responseObject = SearchRepoResponse.stub
            let httpURLResponse = HTTPURLResponse(
                url: URL(string: "https://api.github.com/search/repositories?q=test&order=desc&per_page=20&page=1")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Link": "<https://api.github.com/search/repositories?q=test&order=desc&per_page=20&page=2>; rel=\"next\", <https://api.github.com/search/repositories?q=test&order=desc&per_page=20&page=50>; rel=\"last\""]
            )!
            return ApiResponse(response: responseObject, httpURLResponse: httpURLResponse)
        }
        let gitHubRepoRepositoryImpl = SearchedRepoRepositoryImpl(
            remoteDataSource: searchRepoDataSourceMock,
            searchRepoRequestData: .init(searchQuery: nil, page: 0, hasNext: false)
        )

        // Exercise
        let result = try await gitHubRepoRepositoryImpl.search(searchQuery: "test", page: 1)

        // Verify
        let firstArgValue = searchRepoDataSourceMock.requestArgValues[0]
        XCTAssertEqual(firstArgValue.0, "test")
        XCTAssertEqual(firstArgValue.1, 1)
        XCTAssertEqual(searchRepoDataSourceMock.requestCallCount, 1)
        XCTAssertEqual(result.searchRepoRequestData.hasNext, true)
        result.items.verifyEqualToStub()
    }
}
