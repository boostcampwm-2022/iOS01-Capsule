//
//  UIViewControllerPreview.swift
//  SpaceCapsule
//
//  Created by 장재훈 on 2022/11/18.
//

import Foundation

#if canImport(SwiftUI) && DEBUG
    import SwiftUI
    extension UIViewController {
        private struct Preview: UIViewControllerRepresentable {
            let viewController: UIViewController

            func makeUIViewController(context: Context) -> UIViewController {
                return viewController
            }

            func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
            }
        }

        func showPreview() -> some View {
            Preview(viewController: self)
        }
    }
#endif
