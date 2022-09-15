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

    init(isLoading: Bool) {
        self.isLoading = isLoading
    }
}

extension SearchRepoState {
    func updateLoadingState(isLoading: Bool? = nil) {
        if let isLoading = isLoading {
            self.isLoading = isLoading
        }
    }
}
