//
//  SearchRepoState.swift
//
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Domain
import Foundation

// MARK: - SearchRepoState
actor SearchRepoState {
    var isLoading: Bool
    var page: Int
    var searchQuery: String
    var hasNext: Bool

    init(isLoading: Bool, page: Int, searchQuery: String, hasNext: Bool) {
        self.isLoading = isLoading
        self.page = page
        self.searchQuery = searchQuery
        self.hasNext = hasNext
    }
}

extension SearchRepoState {
    func update(
        isLoading: Bool? = nil,
        page: Int? = nil,
        searchQuery: String? = nil,
        hasNext: Bool? = nil
    ) {
        if let isLoading = isLoading {
            self.isLoading = isLoading
        }
        if let page = page {
            self.page = page
        }
        if let searchQuery = searchQuery {
            self.searchQuery = searchQuery
        }
        if let hasNext = hasNext {
            self.hasNext = hasNext
        }
    }

    func isEnabledSearch(searchQuery: String?) -> Bool {
        guard !isLoading else {
            log("isLoading")
            return false
        }
        guard !searchQuery.isNilOrEmpty else {
            log("searchQuery.isNilOrEmpty")
            return false
        }
        return true
    }

    func isEnabledLoadMore() async -> Bool {
        guard !isLoading else {
            log("isLoading")
            return false
        }
        guard !searchQuery.isEmpty else {
            log("searchQuery.isEmpty")
            return false
        }

        guard hasNext else {
            log("has no next data.")
            return false
        }
        return true
    }
}
