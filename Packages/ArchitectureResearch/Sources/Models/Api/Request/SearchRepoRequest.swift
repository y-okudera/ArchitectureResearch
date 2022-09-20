//
//  SearchRepoRequest.swift
//
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Foundation

public struct SearchRepoRequest: ApiRequestable, Equatable {
    public typealias Response = SearchRepoResponse

    private let searchQuery: String
    private let page: Int
    private let perPage: Int

    public init(searchQuery: String, page: Int, perPage: Int) {
        self.searchQuery = searchQuery
        self.page = page
        self.perPage = perPage
    }

    public let path: String = "/search/repositories"

    public let method: String = "GET"

    public var queryItems: [URLQueryItem]? {
        [
            .init(name: "q", value: searchQuery),
            .init(name: "order", value: "desc"),
            .init(name: "per_page", value: "\(perPage)"),
            .init(name: "page", value: "\(page)"),
        ]
    }
}
