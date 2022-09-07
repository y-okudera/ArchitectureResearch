//
//  WebApiDataSource.swift
//
//
//  Created by okudera on 2022/09/08.
//

import Domain
import Foundation

// MARK: - WebApiDataSource
/// @mockable
/// 上位レイヤーから直接呼び出さず、API毎のDataSourceをつくってAdapterパターンでWrapしてください
public protocol WebApiDataSource {
    func sendRequest<T: ApiRequestable>(_ apiRequest: T) async throws -> ApiResponse<T.Response>
}
