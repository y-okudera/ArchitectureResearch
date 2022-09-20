//
//  LottieView.swift
//
//
//  Created by Yuki Okudera on 2022/09/19.
//

import Lottie
import SwiftUI
import UIKit

#warning("Will modularize")
public struct LottieView: UIViewRepresentable {
    public init(asset: String = "octocat", isAnimating: Binding<Bool>) {
        self.asset = asset
        _isAnimating = isAnimating
    }

    @Binding private var isAnimating: Bool

    var asset: String
    var loopMode: LottieLoopMode = .loop

    public func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        let animationView = AnimationView(asset: asset)

        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = loopMode
        animationView.play()

        animationView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            animationView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            animationView.topAnchor.constraint(equalTo: view.topAnchor),
            animationView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])

        return view
    }

    public func updateUIView(_ uiView: UIViewType, context: Context) {
        uiView.isHidden = !isAnimating
    }
}
