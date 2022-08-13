//
//  SearchRepoRequest.swift
//  
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Foundation

struct SearchRepoRequest: ApiRequestable {
    typealias Response = SearchRepoResponse

    private let searchQuery: String
    private let page: Int

    init(searchQuery: String, page: Int = 1) {
        self.searchQuery = searchQuery
        self.page = page
    }

    var path: String {
        return "/search/repositories"
    }

    var method: String {
        return "GET"
    }

    var queryItems: [URLQueryItem]? {
        return [
            .init(name: "q", value: searchQuery),
            .init(name: "order", value: "desc"),
            .init(name: "per_page", value: "20"),
            .init(name: "page", value: page.description),
        ]
    }
}
