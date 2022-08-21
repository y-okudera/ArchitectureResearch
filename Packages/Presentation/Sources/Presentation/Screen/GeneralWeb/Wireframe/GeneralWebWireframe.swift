//
//  GeneralWebWireframe.swift
//
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Core
import UIKit

// MARK: - GeneralWebWireframe
protocol GeneralWebWireframe: AnyObject {
    var environment: AppEnvironment { get }
    func configure(viewController: UIViewController?)
}

// MARK: - GeneralWebWireframeImpl
final class GeneralWebWireframeImpl: GeneralWebWireframe {

    private weak var viewController: UIViewController?
    let environment: AppEnvironment

    init(environment: AppEnvironment) {
        self.environment = environment
    }

    func configure(viewController: UIViewController?) {
        self.viewController = viewController
    }
}
