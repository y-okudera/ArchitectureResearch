//
//  SearchRepoViewData.swift
//  
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Foundation

public struct SearchRepoViewData {
    public let items: [GitHubRepo]
    public let hasNext: Bool

    public init(items: [GitHubRepo], hasNext: Bool) {
        self.items = items
        self.hasNext = hasNext
    }
}
