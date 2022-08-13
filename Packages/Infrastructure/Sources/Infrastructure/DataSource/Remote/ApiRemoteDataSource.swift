//
//  ApiRemoteDataSource.swift
//  
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Foundation

public protocol ApiRemoteDataSource {
    func sendRequest<T: ApiRequestable>(_ apiRequest: T) async throws -> ApiResponse<T.Response>
}

public struct ApiRemoteDataSourceImpl: ApiRemoteDataSource {
    public let urlSession: URLSession

    public init(urlSession: URLSession) {
        self.urlSession = urlSession
    }

    public func sendRequest<T: ApiRequestable>(_ apiRequest: T) async throws -> ApiResponse<T.Response> {
        guard let urlRequest = apiRequest.urlRequest else {
            throw ApiError.invalidRequest
        }
        do {
            let result = try await urlSession.data(for: urlRequest)
            let apiResponse = try validate(data: result.0, response: result.1, apiRequest: apiRequest)
            return apiResponse
        } catch let apiError as ApiError {
            throw apiError
        } catch {
            throw ApiError(error: error)
        }
    }

    private func validate<T: ApiRequestable>(data: Data, response: URLResponse, apiRequest: T) throws -> ApiResponse<T.Response> {
        guard let httpURLResponse = (response as? HTTPURLResponse) else {
            throw ApiError.invalidResponse(URLError(.badServerResponse))
        }
        switch httpURLResponse.statusCode {
        case 200...299:
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let responseObject = try decoder.decode(T.Response.self, from: data)
                return ApiResponse(response: responseObject, httpURLResponse: httpURLResponse)
            } catch let decodingError as DecodingError {
                throw ApiError.decodeError(decodingError)
            }
        case 400...499:
            throw ApiError.clientError(httpURLResponse.statusCode)
        case 500...599:
            throw ApiError.serverError(httpURLResponse.statusCode)
        default:
            throw ApiError.invalidResponse(URLError(.badServerResponse))
        }
    }
}
