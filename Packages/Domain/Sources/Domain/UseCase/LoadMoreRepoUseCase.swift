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
        let searchRepoRequestData = searchedRepoRepository.readSearchRepoRequestData()
        log("searchRepoRequestData.searchQuery: \(searchRepoRequestData.searchQuery ?? "nil")")
        log("searchRepoRequestData.page: \(searchRepoRequestData.page)")
        log("searchRepoRequestData.hasNext: \(searchRepoRequestData.hasNext)")

        return try await searchedRepoRepository.search(
            searchQuery: searchRepoRequestData.searchQuery ?? "",
            page: searchRepoRequestData.page + 1
        )
    }
}
