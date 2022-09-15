//
//  ReadSearchRepoDataUseCase.swift
//
//
//  Created by okudera on 2022/09/16.
//

import Foundation

// MARK: - ReadSearchRepoDataUseCase
/// @mockable
public protocol ReadSearchRepoDataUseCase {
    func execute() -> SearchRepoData
}

// MARK: - ReadSearchRepoDataInteractor
public struct ReadSearchRepoDataInteractor: ReadSearchRepoDataUseCase {

    private let searchedRepoRepository: SearchedRepoRepository

    public init(searchedRepoRepository: SearchedRepoRepository) {
        self.searchedRepoRepository = searchedRepoRepository
    }

    public func execute() -> SearchRepoData {
        log()
        return searchedRepoRepository.readSearchRepoData()
    }
}
