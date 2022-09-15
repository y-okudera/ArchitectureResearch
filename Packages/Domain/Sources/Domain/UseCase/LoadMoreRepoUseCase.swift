//
//  LoadMoreRepoUseCase.swift
//
//
//  Created by okudera on 2022/09/16.
//

import Foundation

// MARK: - LoadMoreRepoUseCase
/// @mockable
public protocol LoadMoreRepoUseCase {
    func execute() async throws -> SearchedRepo
}

// MARK: - LoadMoreRepoInteractor
public struct LoadMoreRepoInteractor: LoadMoreRepoUseCase {

    private let searchedRepoRepository: SearchedRepoRepository

    public init(searchedRepoRepository: SearchedRepoRepository) {
        self.searchedRepoRepository = searchedRepoRepository
    }

    public func execute() async throws -> SearchedRepo {
        let searchRepoData = searchedRepoRepository.readSearchRepoData()
        log("searchRepoData.searchQuery: \(searchRepoData.searchQuery ?? "nil")")
        log("searchRepoData.page: \(searchRepoData.page)")
        log("searchRepoData.hasNext: \(searchRepoData.hasNext)")

        return try await searchedRepoRepository.search(
            searchQuery: searchRepoData.searchQuery ?? "",
            page: searchRepoData.page + 1
        )
    }
}
