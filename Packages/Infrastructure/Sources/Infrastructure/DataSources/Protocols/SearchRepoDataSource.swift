//
//  SearchRepoDataSource.swift
//
//
//  Created by okudera on 2022/09/07.
//

import Domain
import Foundation

// MARK: - SearchRepoDataSource
/// @mockable
public protocol SearchRepoDataSource {
    func request(searchQuery: String, page: Int) async throws -> ApiResponse<SearchRepoResponse>
}
