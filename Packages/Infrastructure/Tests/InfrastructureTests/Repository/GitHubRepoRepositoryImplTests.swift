//
//  GitHubRepoRepositoryImplTests.swift
//
//
//  Created by Yuki Okudera on 2022/08/14.
//

@testable import Infrastructure
import XCTest

final class GitHubRepoRepositoryImplTests: XCTestCase {

    func testSearch() async throws {
        // Setup
        let apiRemoteDataSourceMock = ApiRemoteDataSourceMock()
        apiRemoteDataSourceMock.sendRequestHandler = { _ in
            let responseObject = SearchRepoResponse.stub
            let httpURLResponse = HTTPURLResponse(
                url: URL(string: "https://api.github.com/search/repositories?q=test&order=desc&per_page=20&page=1")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Link": "<https://api.github.com/search/repositories?q=test&order=desc&per_page=20&page=2>; rel=\"next\", <https://api.github.com/search/repositories?q=test&order=desc&per_page=20&page=50>; rel=\"last\""]
            )!
            return ApiResponse(response: responseObject, httpURLResponse: httpURLResponse)
        }
        let gitHubRepoRepositoryImpl = GitHubRepoRepositoryImpl(apiRemoteDataSource: apiRemoteDataSourceMock)

        // Exercise
        let result = try await gitHubRepoRepositoryImpl.search(searchQuery: "test", page: 1)

        // Verify
        let firstArgValue = apiRemoteDataSourceMock.sendRequestArgValues[0] as! SearchRepoRequest
        XCTAssertEqual(firstArgValue, .init(searchQuery: "test", page: 1))
        XCTAssertEqual(apiRemoteDataSourceMock.sendRequestCallCount, 1)
        XCTAssertEqual(result.hasNext, true)
        result.items.verifyEqualToStub()
    }
}
