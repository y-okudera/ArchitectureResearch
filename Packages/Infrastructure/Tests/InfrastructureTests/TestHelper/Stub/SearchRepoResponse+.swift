//
//  SearchRepoResponse+.swift
//
//
//  Created by Yuki Okudera on 2022/08/17.
//

import Infrastructure

extension SearchRepoResponse {
    static var stub: Self {
        StubBuilder.build(forResource: "search_repositories", withExtension: "json")
    }
}
