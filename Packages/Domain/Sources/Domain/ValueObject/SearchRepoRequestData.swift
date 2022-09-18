//
//  SearchRepoRequestData.swift
//
//
//  Created by okudera on 2022/09/16.
//

import Foundation

// MARK: - SearchRepoRequestData
public final class SearchRepoRequestData {
    public private(set) var searchQuery: String?
    public private(set) var page: Int
    public private(set) var hasNext: Bool

    public init(searchQuery: String?, page: Int, hasNext: Bool) {
        self.searchQuery = searchQuery
        self.page = page
        self.hasNext = hasNext
    }

    public func update(searchQuery: String, page: Int, hasNext: Bool) {
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
extension SearchRepoRequestData: Equatable {
    public static func == (lhs: SearchRepoRequestData, rhs: SearchRepoRequestData) -> Bool {
        lhs.searchQuery == rhs.searchQuery && lhs.page == rhs.page && lhs.hasNext == rhs.hasNext
    }
}
