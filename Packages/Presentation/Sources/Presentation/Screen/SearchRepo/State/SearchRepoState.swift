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
    nonisolated let viewData: SearchRepoViewData
    var isLoading: Bool
    var page: Int
    var searchQuery: String

    init(isLoading: Bool, page: Int, searchQuery: String, viewData: SearchRepoViewData) {
        self.isLoading = isLoading
        self.page = page
        self.searchQuery = searchQuery
        self.viewData = viewData
    }
}

extension SearchRepoState {
    func update(isLoading: Bool) {
        self.isLoading = isLoading
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

        let itemsIsEmpty = await viewData.items.isEmpty
        guard !itemsIsEmpty else {
            log("viewData.items.isEmpty")
            return false
        }

        let hasNext = await viewData.hasNext
        guard hasNext else {
            log("has no next data.")
            return false
        }
        return true
    }
}
