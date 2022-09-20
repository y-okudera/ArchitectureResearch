//
//  ApiDecode.swift
//
//
//  Created by Yuki Okudera on 2022/09/19.
//

import Combine
import ComposableArchitecture
import Foundation
import Models

extension URLSession.DataTaskPublisher {
    func apiDecode<T: ApiRequestable>(
        as type: T
    ) -> Effect<ApiResponse<T.Response>, ApiError> {
        tryMap {
            guard let httpURLResponse = $0.response as? HTTPURLResponse else {
                throw ApiError.invalidResponse(URLError(.badServerResponse))
            }
            switch httpURLResponse.statusCode {
            case 200 ... 299:
                do {
                    let decoder = JSONDecoder()
                    decoder.keyDecodingStrategy = .convertFromSnakeCase
                    let responseObject = try decoder.decode(T.Response.self, from: $0.data)
                    return ApiResponse(response: responseObject, httpURLResponse: httpURLResponse)
                } catch let decodingError as DecodingError {
                    throw ApiError.decodeError(decodingError)
                }
            case 400 ... 499:
                throw ApiError.clientError(httpURLResponse.statusCode)
            case 500 ... 599:
                throw ApiError.serverError(httpURLResponse.statusCode)
            default:
                throw ApiError.invalidResponse(URLError(.badServerResponse))
            }
        }
        .mapError { ApiError(error: $0) }
        .eraseToAnyPublisher()
        .eraseToEffect()
    }
}
