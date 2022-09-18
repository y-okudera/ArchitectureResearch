//
//  ReadSearchRepoRequestDataUseCase.swift
//
//
//  Created by okudera on 2022/09/16.
//

import Foundation

// MARK: - ReadSearchRepoRequestDataUseCase
/// @mockable
public protocol ReadSearchRepoRequestDataUseCase {
    func execute() -> SearchRepoRequestData
}

// MARK: - ReadSearchRepoRequestDataInteractor
public struct ReadSearchRepoRequestDataInteractor: ReadSearchRepoRequestDataUseCase {

    private let searchedRepoRepository: SearchedRepoRepository

    public init(searchedRepoRepository: SearchedRepoRepository) {
        self.searchedRepoRepository = searchedRepoRepository
    }

    public func execute() -> SearchRepoRequestData {
        log()
        return searchedRepoRepository.readSearchRepoRequestData()
    }
}
