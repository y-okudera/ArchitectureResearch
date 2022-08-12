//
//  SearchRepoViewData.swift
//  
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Foundation

public struct SearchRepoViewData {
    public private(set) var hasNext: Bool
    public private(set) var items: [GitHubRepo]

    public init(hasNext: Bool, items: [GitHubRepo]) {
        self.hasNext = hasNext
        self.items = items
    }

    public mutating func append(viewData: SearchRepoViewData) {
        self.hasNext = viewData.hasNext
        self.items.append(contentsOf: viewData.items)
    }
}
