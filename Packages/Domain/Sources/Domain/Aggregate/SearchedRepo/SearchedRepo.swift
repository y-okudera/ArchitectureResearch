//
//  SearchedRepo.swift
//
//
//  Created by okudera on 2022/09/16.
//

import Foundation

public struct SearchedRepo: Equatable {
    public let items: [GitHubRepo]
    public let searchRepoData: SearchRepoData = .shared

    public init(items: [GitHubRepo], searchQuery: String, page: Int, hasNext: Bool) {
        self.items = items
        searchRepoData.update(searchQuery: searchQuery, page: page, hasNext: hasNext)
    }
}
