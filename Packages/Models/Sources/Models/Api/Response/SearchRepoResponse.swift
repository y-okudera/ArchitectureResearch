//
//  SearchRepoResponse.swift
//
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Foundation

// MARK: - SearchRepoResponse
public struct SearchRepoResponse: Decodable, Equatable {
    public let items: [GitHubRepo]
}

// MARK: - Mock
extension SearchRepoResponse {
    public static var mock: SearchRepoResponse {
        SearchRepoResponse(
            items: .mock
        )
    }
}
