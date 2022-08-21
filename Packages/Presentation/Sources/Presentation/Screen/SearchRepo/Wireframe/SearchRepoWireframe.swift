//
//  SearchRepoWireframe.swift
//
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Core
import UIKit

// MARK: - SearchRepoWireframe
/// @mockable
protocol SearchRepoWireframe: AnyObject {
    var environment: AppEnvironment { get }
    func configure(viewController: UIViewController?)
    func pushGeneralWebView(initialUrl: URL)
}

// MARK: - SearchRepoWireframeImpl
final class SearchRepoWireframeImpl: SearchRepoWireframe {

    private weak var viewController: UIViewController?
    let environment: AppEnvironment

    init(environment: AppEnvironment) {
        self.environment = environment
    }

    func configure(viewController: UIViewController?) {
        self.viewController = viewController
    }

    func pushGeneralWebView(initialUrl: URL) {
        let generalWebVC = GeneralWebViewBuilder.build(environment: environment, initialUrl: initialUrl)
        viewController?.navigationController?.pushViewController(generalWebVC, animated: true)
    }
}
