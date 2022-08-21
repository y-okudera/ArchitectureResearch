//
//  SearchRepoRequest.swift
//
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Foundation

struct SearchRepoRequest: ApiRequestable, Equatable {
    typealias Response = SearchRepoResponse

    private let searchQuery: String
    private let page: Int

    init(searchQuery: String, page: Int) {
        self.searchQuery = searchQuery
        self.page = page
    }

    let path: String = "/search/repositories"

    let method: String = "GET"

    var queryItems: [URLQueryItem]? {
        [
            .init(name: "q", value: searchQuery),
            .init(name: "order", value: "desc"),
            .init(name: "per_page", value: "20"),
            .init(name: "page", value: "\(page)"),
        ]
    }
}
