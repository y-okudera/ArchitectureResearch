//
//  SearchRepoViewData.swift
//
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Foundation

public actor SearchRepoViewData {
    public let hasNext: Bool
    public let items: [GitHubRepo]

    public init(hasNext: Bool, items: [GitHubRepo]) {
        self.hasNext = hasNext
        self.items = items
    }

    public nonisolated var numberOfItems: Int {
        items.count
    }
}
