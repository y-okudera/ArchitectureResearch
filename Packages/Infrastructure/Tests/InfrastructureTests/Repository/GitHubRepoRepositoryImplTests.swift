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
            let responseObject: SearchRepoResponse = try StubBuilder.build(assetName: "search_repositories")
            let httpURLResponse = HTTPURLResponse(
                url: URL(string: "https://api.github.com/search/repositories?q=Swift&order=desc&per_page=20&page=1")!,
                statusCode: 200,
                httpVersion: nil,
                headerFields: ["Link": "<https://api.github.com/search/repositories?q=Swift&order=desc&per_page=20&page=2>; rel=\"next\", <https://api.github.com/search/repositories?q=Swift&order=desc&per_page=20&page=50>; rel=\"last\""]
            )!
            return ApiResponse(response: responseObject, httpURLResponse: httpURLResponse)
        }
        let gitHubRepoRepositoryImpl = GitHubRepoRepositoryImpl(apiRemoteDataSource: apiRemoteDataSourceMock)

        // Exercise
        let result = try await gitHubRepoRepositoryImpl.search(searchQuery: "test", page: 1)

        // Verify
        let hasNext = await result.hasNext
        XCTAssertEqual(hasNext, true)
        XCTAssertEqual(result.numberOfItems, 1)
        let firstArgValue = apiRemoteDataSourceMock.sendRequestArgValues[0] as! SearchRepoRequest
        XCTAssertEqual(firstArgValue.queryItems?[0], .init(name: "q", value: "test"))
        XCTAssertEqual(firstArgValue.queryItems?[1], .init(name: "order", value: "desc"))
        XCTAssertEqual(firstArgValue.queryItems?[2], .init(name: "per_page", value: "20"))
        XCTAssertEqual(firstArgValue.queryItems?[3], .init(name: "page", value: "1"))
        XCTAssertEqual(apiRemoteDataSourceMock.sendRequestCallCount, 1)
    }
}
