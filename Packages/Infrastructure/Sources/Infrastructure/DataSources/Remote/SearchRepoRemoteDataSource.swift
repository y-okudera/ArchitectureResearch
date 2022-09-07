//
//  SearchRepoRemoteDataSource.swift
//
//
//  Created by okudera on 2022/09/07.
//

import Domain
import Foundation

// MARK: - SearchRepoRemoteDataSource
public struct SearchRepoRemoteDataSource: SearchRepoDataSource {
    private let webApiDataSource: WebApiDataSource

    public init(webApiDataSource: WebApiDataSource) {
        self.webApiDataSource = webApiDataSource
    }

    public func request(searchQuery: String, page: Int) async throws -> ApiResponse<SearchRepoResponse> {
        let request = SearchRepoRequest(searchQuery: searchQuery, page: page)
        let result = try await webApiDataSource.sendRequest(request)
        guard !result.response.items.isEmpty else {
            throw SearchRepoError.noResults
        }
        return result
    }
}
