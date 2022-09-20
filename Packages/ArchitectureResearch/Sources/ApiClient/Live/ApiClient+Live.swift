//
//  ApiClient+Live.swift
//
//
//  Created by Yuki Okudera on 2022/09/19.
//

import Combine
import ComposableArchitecture
import Foundation
import Models

// MARK: - Live

extension ApiClient {
    public static let live = Self(
        searchRepo: { requestPublisher($0).eraseToEffect() }
    )

    private static func requestPublisher<T: ApiRequestable>(
        _ apiRequest: T
    ) -> Effect<ApiResponse<T.Response>, ApiError> {
        guard let urlRequest = apiRequest.urlRequest else {
            return Fail(error: ApiError.invalidRequest)
                .eraseToAnyPublisher()
                .eraseToEffect()
        }
        return URLSession.shared.dataTaskPublisher(for: urlRequest)
            .apiDecode(as: apiRequest.self)
    }
}
