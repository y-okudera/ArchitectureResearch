//
//  ApiClient+Mock.swift
//
//
//  Created by Yuki Okudera on 2022/09/19.
//

import Combine
import ComposableArchitecture
import Models

// MARK: - Mock

extension ApiClient {
    public static func mock(
        searchRepo: @escaping (SearchRepoRequest) -> SearchRepoEffect = { _ in fatalError("Unmocked") }
    ) -> Self {
        Self(
            searchRepo: searchRepo
        )
    }

    public static func mockPreview(
        searchRepo: @escaping (SearchRepoRequest) -> SearchRepoEffect = { _ in .init(value: .init(response: .mock, httpURLResponse: .init())) }
    ) -> Self {
        Self(
            searchRepo: searchRepo
        )
    }
}
