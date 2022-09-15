//
//  SearchedRepoRepository.swift
//
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Foundation

/// @mockable
public protocol SearchedRepoRepository {
    func search(searchQuery: String, page: Int) async throws -> SearchedRepo

    func readSearchRepoData() -> SearchRepoData
}
