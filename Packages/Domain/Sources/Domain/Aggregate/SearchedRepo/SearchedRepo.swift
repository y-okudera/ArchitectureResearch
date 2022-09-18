//
//  SearchedRepo.swift
//
//
//  Created by okudera on 2022/09/16.
//

import Foundation

public struct SearchedRepo: Equatable {
    public let items: [GitHubRepo]
    public let searchRepoRequestData: SearchRepoRequestData

    public init(items: [GitHubRepo], searchRepoRequestData: SearchRepoRequestData) {
        self.items = items
        self.searchRepoRequestData = searchRepoRequestData
    }
}
