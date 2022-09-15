//
//  SearchRepoData.swift
//
//
//  Created by okudera on 2022/09/16.
//

import Foundation

// MARK: - SearchRepoData
public final class SearchRepoData {
    public private(set) var searchQuery: String?
    public private(set) var page: Int
    public private(set) var hasNext: Bool

    public static let shared = SearchRepoData(searchQuery: nil, page: 0, hasNext: false)

    private init(searchQuery: String?, page: Int, hasNext: Bool) {
        self.searchQuery = searchQuery
        self.page = page
        self.hasNext = hasNext
    }

    /// Domainパッケージ内でのみアップデートをさせるため、internalにしています
    func update(searchQuery: String, page: Int, hasNext: Bool) {
        self.searchQuery = searchQuery
        self.page = page
        self.hasNext = hasNext
    }

    public func isEnabledLoadMore(isLoading: Bool) async -> Bool {
        guard !isLoading else {
            log("isLoading")
            return false
        }
        guard !searchQuery.isNilOrEmpty else {
            log("searchQuery.isNilOrEmpty")
            return false
        }

        guard hasNext else {
            log("has no next data.")
            return false
        }
        return true
    }
}

// MARK: Equatable
extension SearchRepoData: Equatable {
    public static func == (lhs: SearchRepoData, rhs: SearchRepoData) -> Bool {
        lhs.searchQuery == rhs.searchQuery && lhs.page == rhs.page && lhs.hasNext == rhs.hasNext
    }
}
