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
            self.backgroundColor = .black.withAlphaComponent(0.4)
            self.isUserInteractionEnabled = true
        } else {
            self.backgroundColor = .clear
            self.isUserInteractionEnabled = false
        }
        animationView.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(animationView)
        NSLayoutConstraint.activate([
            animationView.widthAnchor.constraint(equalToConstant: max(100, self.frame.width / 3)),
            animationView.heightAnchor.constraint(equalToConstant: max(100, self.frame.width / 3)),
            animationView.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            animationView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
        ])
    }
}
