//
//  SearchRepoUseCase.swift
//
//
//  Created by Yuki Okudera on 2022/08/16.
//

import Foundation

// MARK: - SearchRepoUseCase
/// @mockable
public protocol SearchRepoUseCase {
    func execute(searchQuery: String) async throws -> SearchedRepo
}

// MARK: - SearchRepoInteractor
public struct SearchRepoInteractor: SearchRepoUseCase {

    private let searchedRepoRepository: SearchedRepoRepository

    public init(searchedRepoRepository: SearchedRepoRepository) {
        self.searchedRepoRepository = searchedRepoRepository
    }

    public func execute(searchQuery: String) async throws -> SearchedRepo {
        log()
        return try await searchedRepoRepository.search(searchQuery: searchQuery, page: 1)
    }
}
