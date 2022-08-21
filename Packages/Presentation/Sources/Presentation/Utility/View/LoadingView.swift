//
//  LoadingView.swift
//
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Lottie
import UIKit

final class LoadingView: UIView {
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    func setup(isOverlay: Bool, lottieAssetName: String) {
        let animationView = AnimationView(asset: lottieAssetName)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        animationView.play()

        if isOverlay {
            backgroundColor = .black.withAlphaComponent(0.4)
            isUserInteractionEnabled = true
        } else {
            backgroundColor = .clear
            isUserInteractionEnabled = false
        }
        animationView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalToConstant: max(100, frame.width / 3)),
            animationView.heightAnchor.constraint(equalToConstant: max(100, frame.width / 3)),
            animationView.centerXAnchor.constraint(equalTo: centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: centerYAnchor),
        ])
    }
}
