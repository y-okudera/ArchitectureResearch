//
//  AppDelegateCore.swift
//
//
//  Created by Yuki Okudera on 2022/09/19.
//

import ApiClient
import ComposableArchitecture
import Logger
import SwiftUI

public enum AppDelegateCore {
    // MARK: - State

    public struct State: Equatable {
        public init() {}
    }

    // MARK: - Action

    public enum Action: Equatable {
        case didFinishLaunching
    }

    // MARK: - Environment

    public struct Environment {}

    // MARK: - Reducer

    public static let reducer =
        Reducer<State, Action, Environment> { _, action, _ in
            switch action {
            case .didFinishLaunching:
                log(".didFinishLaunching")
                return .none
            }
        }
}
