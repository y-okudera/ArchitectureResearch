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
    private let searchRepoRequestData: SearchRepoRequestData

    public init(remoteDataSource: SearchRepoDataSource, searchRepoRequestData: SearchRepoRequestData) {
        self.remoteDataSource = remoteDataSource
        self.searchRepoRequestData = searchRepoRequestData
    }

    public func search(searchQuery: String, page: Int) async throws -> SearchedRepo {
        let result = try await remoteDataSource.request(searchQuery: searchQuery, page: page)
        guard !result.response.items.isEmpty else {
            throw SearchRepoError.noResults
        }
        searchRepoRequestData.update(searchQuery: searchQuery, page: page, hasNext: result.gitHubApiPagination?.hasNext ?? false)

        return .init(items: result.response.items, searchRepoRequestData: searchRepoRequestData)
    }

    public func readSearchRepoRequestData() -> SearchRepoRequestData {
        searchRepoRequestData
    }
}
