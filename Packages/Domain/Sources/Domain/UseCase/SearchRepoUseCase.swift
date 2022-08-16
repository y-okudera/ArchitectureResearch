//
//  SearchRepoUseCase.swift
//  
//
//  Created by Yuki Okudera on 2022/08/16.
//

import Foundation

/// @mockable
public protocol SearchRepoUseCase {
    func execute(searchQuery: String, page: Int) async throws -> SearchRepoViewData
}

public struct SearchRepoUseCaseImpl: SearchRepoUseCase {

    private let gitHubRepoRepository: GitHubRepoRepository

    public init(gitHubRepoRepository: GitHubRepoRepository) {
        self.gitHubRepoRepository = gitHubRepoRepository
    }

    public func execute(searchQuery: String, page: Int) async throws -> SearchRepoViewData {
        let result = try await gitHubRepoRepository.search(searchQuery: searchQuery, page: page)
        return .init(hasNext: result.hasNext, items: result.items)
    }
}
