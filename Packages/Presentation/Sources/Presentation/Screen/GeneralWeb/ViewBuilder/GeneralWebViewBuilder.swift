//
//  GeneralWebViewBuilder.swift
//
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Core
import UIKit

enum GeneralWebViewBuilder {
    static func build(environment: AppEnvironment, initialUrl: URL) -> UIViewController {
        let wireFrame = GeneralWebWireframeImpl(environment: environment)
        let presenter = GeneralWebPresenterImpl(
            state: .init(initialUrl: initialUrl),
            wireframe: wireFrame
        )
        let viewController = GeneralWebViewController.instantiate()

        viewController.configure(presenter: presenter)
        wireFrame.configure(viewController: viewController)

        return viewController
    }
}
