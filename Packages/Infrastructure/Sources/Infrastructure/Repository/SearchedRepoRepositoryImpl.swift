//
//  SearchedRepoRepositoryImpl.swift
//
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Domain
import Foundation

public struct SearchedRepoRepositoryImpl: SearchedRepoRepository {

    private let remoteDataSource: SearchRepoDataSource
    private let searchRepoData: SearchRepoData

    public init(remoteDataSource: SearchRepoDataSource, searchRepoData: SearchRepoData = .shared) {
        self.remoteDataSource = remoteDataSource
        self.searchRepoData = searchRepoData
    }

    public func search(searchQuery: String, page: Int) async throws -> SearchedRepo {
        let result = try await remoteDataSource.request(searchQuery: searchQuery, page: page)
        guard !result.response.items.isEmpty else {
            throw SearchRepoError.noResults
        }
        return .init(
            items: result.response.items,
            searchQuery: searchQuery,
            page: page,
            hasNext: result.gitHubApiPagination?.hasNext ?? false
        )
    }

    public func readSearchRepoData() -> SearchRepoData {
        searchRepoData
    }
}
