//
//  App.swift
//  ArchitectureResearch
//
//  Created by Yuki Okudera on 2022/09/19.
//

import AppFeature
import ComposableArchitecture
import SwiftUI

// MARK: - AppDelegate
final class AppDelegate: NSObject, UIApplicationDelegate {
    let store = Store(
        initialState: .init(),
        reducer: AppCore.reducer,
        environment: .live
    )
    lazy var viewStore = ViewStore(
        self.store.scope(state: { _ in () }),
        removeDuplicates: ==
    )

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil
    ) -> Bool {
        viewStore.send(.appDelegate(.didFinishLaunching))
        return true
    }
}

// MARK: - SwiftUIComposableArchitectureApp
@main
struct SwiftUIComposableArchitectureApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) private var appDelegate
    @Environment(\.scenePhase) private var scenePhase

    var body: some Scene {
        WindowGroup {
            AppView(store: self.appDelegate.store)
        }
    }
}

// MARK: AppCore.Environment live

extension AppCore.Environment {
    static let live = Self(
        apiClient: .live,
        mainQueue: DispatchQueue.main.eraseToAnyScheduler(),
        uuid: UUID.init
    )
}
