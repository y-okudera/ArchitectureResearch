//
//  SearchRepoState.swift
//  
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Domain
import Foundation

struct SearchRepoState {
    var isLoading: Bool
    var page: Int
    var searchQuery: String
    var viewData: SearchRepoViewData

    init(isLoading: Bool, page: Int, searchQuery: String, viewData: SearchRepoViewData) {
        self.isLoading = isLoading
        self.page = page
        self.searchQuery = searchQuery
        self.viewData = viewData
    }

    mutating func update(
        isLoading: Bool? = nil,
        page: Int? = nil,
        searchQuery: String? = nil,
        viewData: SearchRepoViewData? = nil
    ) {
        self.isLoading = isLoading ?? self.isLoading
        self.page = page ?? self.page
        self.searchQuery = searchQuery ?? self.searchQuery
        self.viewData = viewData ?? self.viewData
    }
}
