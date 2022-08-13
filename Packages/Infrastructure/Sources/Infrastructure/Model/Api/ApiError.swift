//
//  ApiError.swift
//  
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Foundation

public enum ApiError: LocalizedError {
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

extension ApiError {
    public var errorDescription: String? {
        switch self {
        case .cannotConnected:
            return "通信エラーが発生しました。"
        case .invalidRequest:
            return "不正なリクエストです。"
        case .invalidResponse(let error):
            return "不正なレスポンスです。\n\(error.localizedDescription)"
        case .clientError(let statusCode):
            return "クライアントエラーが発生しました。(\(statusCode))"
        case .serverError(let statusCode):
            return "サーバエラーが発生しました。(\(statusCode))"
        case .decodeError(let decodingError):
            return "デコードエラーが発生しました。\n\(decodingError.localizedDescription)"
        case .unknown(let error):
            return "予期せぬエラーが発生しました。\n\(error.localizedDescription)"
        }
    }
}
