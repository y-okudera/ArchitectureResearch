//
//  GitHubRepoRepositoryImpl.swift
//  
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Domain
import Foundation

public struct GitHubRepoRepositoryImpl: GitHubRepoRepository {

    public let apiRemoteDataSource: ApiRemoteDataSource

    public init(apiRemoteDataSource: ApiRemoteDataSource) {
        self.apiRemoteDataSource = apiRemoteDataSource
    }

    public func search(searchQuery: String, page: Int) async throws -> SearchRepoViewData {
        let request = SearchRepoRequest(searchQuery: searchQuery, page: page)
        let result = try await apiRemoteDataSource.sendRequest(request)
        return SearchRepoViewData(hasNext: result.gitHubApiPagination?.hasNext ?? false, items: result.response.items)
    }
}
