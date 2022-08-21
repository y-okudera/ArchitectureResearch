//
//  GitHubRepoRepository.swift
//
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Foundation

/// @mockable
public protocol GitHubRepoRepository {
    func search(searchQuery: String, page: Int) async throws -> (hasNext: Bool, items: [GitHubRepo])
}
