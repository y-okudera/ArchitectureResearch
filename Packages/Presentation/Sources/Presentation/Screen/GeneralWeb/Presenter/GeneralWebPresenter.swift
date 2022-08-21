//
//  GeneralWebPresenter.swift
//
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Domain
import Foundation

// MARK: - GeneralWebPresenter
protocol GeneralWebPresenter {
    var state: GeneralWebState { get }
}

// MARK: - GeneralWebPresenterImpl
final class GeneralWebPresenterImpl: GeneralWebPresenter {

    private(set) var state: GeneralWebState
    private let wireframe: GeneralWebWireframe

    init(state: GeneralWebState, wireframe: GeneralWebWireframe) {
        self.state = state
        self.wireframe = wireframe
    }
}
