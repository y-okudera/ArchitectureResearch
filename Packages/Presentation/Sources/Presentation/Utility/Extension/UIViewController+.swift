//
//  UIViewController+.swift
//  
//
//  Created by Yuki Okudera on 2022/08/12.
//

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
        await withCheckedContinuation { [weak self] (continuation: CheckedContinuation<Void, Never>) -> Void in
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(
                UIAlertAction(title: actionTitle, style: .default) { _ in
                    return continuation.resume()
                }
            )
            self?.present(alert, animated: true)
        }
    }
}
