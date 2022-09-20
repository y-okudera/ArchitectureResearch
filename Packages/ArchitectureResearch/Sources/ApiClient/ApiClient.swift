//
//  ApiClient.swift
//
//
//  Created by Yuki Okudera on 2022/09/19.
//

import Combine
import ComposableArchitecture
import Models

public struct ApiClient {
    public typealias SearchRepoEffect = Effect<ApiResponse<SearchRepoResponse>, ApiError>
    public var searchRepo: (_ request: SearchRepoRequest) -> SearchRepoEffect
}
