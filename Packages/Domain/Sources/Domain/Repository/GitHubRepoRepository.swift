//
//  GitHubRepoRepository.swift
//  
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Foundation

public protocol GitHubRepoRepository {
    func search(searchQuery: String, page: Int) async throws -> SearchRepoViewData
}
