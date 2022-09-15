//
//  SearchRepoViewBuilder.swift
//
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Core
import UIKit

public enum SearchRepoViewBuilder {
    public static func build(environment: AppEnvironment) -> UIViewController {
        let wireFrame = SearchRepoWireframeImpl(environment: environment)
        let presenter = SearchRepoPresenterImpl(
            state: .init(isLoading: false),
            searchRepoUseCase: environment.searchRepoUseCase,
            loadMoreRepoUseCase: environment.loadMoreRepoUseCase,
            readSearchRepoDataUseCase: environment.readSearchRepoDataUseCase,
            wireframe: wireFrame
        )

        let viewController = SearchRepoViewController.instantiate()

        viewController.configure(presenter: presenter)
        wireFrame.configure(viewController: viewController)

        return viewController
    }
}
