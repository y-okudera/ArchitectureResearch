//
//  UIViewController+.swift
//
//
//  Created by Yuki Okudera on 2022/08/12.
//

import Lottie
import UIKit

extension UIViewController {
    static func instantiate() -> Self {
        let className = String(describing: self)
        let storyboard = UIStoryboard(name: className, bundle: .module)
        guard let viewController = storyboard.instantiateViewController(withIdentifier: className) as? Self else {
            fatalError("failed to instantiate")
        }
        return viewController
    }

    func showAlert(title: String?, message: String?, actionTitle: String) async {
        await withCheckedContinuation { [weak self] (continuation: CheckedContinuation<Void, Never>) in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(
                UIAlertAction(title: actionTitle, style: .default) { _ in
                    continuation.resume()
                }
            )
            self?.present(alert, animated: true)
        }
    }

    func showLoading(isOverlay: Bool) {
        hideLoading()

        let loadingView = LoadingView(frame: view.frame)
        loadingView.setup(isOverlay: isOverlay, lottieAssetName: "octocat")
        loadingView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(loadingView)
        NSLayoutConstraint.activate([
            loadingView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            loadingView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            loadingView.topAnchor.constraint(equalTo: view.topAnchor),
            loadingView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }

    func hideLoading() {
        view.findViews(subclassOf: LoadingView.self)
            .forEach { $0.removeFromSuperview() }
    }
}
