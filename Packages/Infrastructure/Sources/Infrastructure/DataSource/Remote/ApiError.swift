//
//  ApiError.swift
//  
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Foundation

public enum ApiError: Error {
    /// 通信エラー
    case cannotConnected
    /// 不正なリクエスト
    case invalidRequest
    /// 不正なレスポンス
    case invalidResponse(Error)
    /// ステータスコード400番台
    case clientError(Int)
    /// ステータスコード500番台
    case serverError(Int)
    /// レスポンスデータのdecodeに失敗
    case decodeError(DecodingError)
    /// その他のエラー
    case unknown(Error)

    public init(error: Error) {
        if let apiError = error as? ApiError {
            self = apiError
            return
        }

        if let urlError = error as? URLError {
            switch urlError.code {
            case .timedOut,
                    .cannotFindHost,
                    .cannotConnectToHost,
                    .networkConnectionLost,
                    .dnsLookupFailed,
                    .httpTooManyRedirects,
                    .resourceUnavailable,
                    .notConnectedToInternet,
                    .secureConnectionFailed,
                    .cannotLoadFromNetwork:
                self = ApiError.cannotConnected
            default:
                self = ApiError.unknown(error)
            }
            return
        }

        // errorがApiErrorでもURLErrorでもない場合
        self = ApiError.unknown(error)
    }
}
