//
//  GitHubRepoRepositoryImpl.swift
//
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Domain
import Foundation

public struct GitHubRepoRepositoryImpl: GitHubRepoRepository {

    private let remoteDataSource: SearchRepoDataSource

    public init(remoteDataSource: SearchRepoDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    public func search(searchQuery: String, page: Int) async throws -> (hasNext: Bool, items: [GitHubRepo]) {
        let result = try await remoteDataSource.request(searchQuery: searchQuery, page: page)
        guard !result.response.items.isEmpty else {
            throw SearchRepoError.noResults
        }
        return (hasNext: result.gitHubApiPagination?.hasNext ?? false, items: result.response.items)
    }
}
