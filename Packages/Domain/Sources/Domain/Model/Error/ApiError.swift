//
//  ApiError.swift
//
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Foundation

// MARK: - ApiError
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

// MARK: LocalizedError
extension ApiError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .cannotConnected:
            return "通信エラーが発生しました。"
        case .invalidRequest:
            return "不正なリクエストです。"
        case let .invalidResponse(error):
            return "不正なレスポンスです。\n\(error.localizedDescription)"
        case let .clientError(statusCode):
            return "クライアントエラーが発生しました。(\(statusCode))"
        case let .serverError(statusCode):
            return "サーバエラーが発生しました。(\(statusCode))"
        case let .decodeError(decodingError):
            return "デコードエラーが発生しました。\n\(decodingError.localizedDescription)"
        case let .unknown(error):
            return "予期せぬエラーが発生しました。\n\(error.localizedDescription)"
        }
    }

    public var recoverySuggestion: String? {
        switch self {
        case .cannotConnected:
            return "通信状況をご確認し、再度お試しください。"
        case .invalidRequest:
            return nil
        case let .invalidResponse(error):
            return (error as NSError).localizedRecoverySuggestion
        case .clientError:
            return nil
        case .serverError:
            return nil
        case let .decodeError(decodingError):
            return (decodingError as NSError).localizedRecoverySuggestion
        case let .unknown(error):
            return (error as NSError).localizedRecoverySuggestion
        }
    }
}

// MARK: CustomNSError
extension ApiError: CustomNSError {

    /// The domain of the error.
    public static var errorDomain: String {
        "Domain.ApiError"
    }

    /// The error code within the given domain.
    public var errorCode: Int {
        switch self {
        case .cannotConnected:
            return 0
        case .invalidRequest:
            return 1
        case .invalidResponse:
            return 2
        case .clientError:
            return 3
        case .serverError:
            return 4
        case .decodeError:
            return 5
        case .unknown:
            return 6
        }
    }

    /// The user-info dictionary.
    public var errorUserInfo: [String: Any] {
        switch self {
        case .cannotConnected:
            return [:]
        case .invalidRequest:
            return [:]
        case let .invalidResponse(error):
            return (error as NSError).userInfo
        case .clientError:
            return [:]
        case .serverError:
            return [:]
        case let .decodeError(decodingError):
            return (decodingError as NSError).userInfo
        case let .unknown(error):
            return (error as NSError).userInfo
        }
    }
}
