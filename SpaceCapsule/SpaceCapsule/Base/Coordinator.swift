//
//  Coordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit

protocol Coordinator: AnyObject {
    var parent: Coordinator? { get set }
    var children: [Coordinator] { get set }
    var navigationController: CustomNavigationController? { get set }

    func start()
}

extension Coordinator {
    func pop() -> Coordinator? {
        let parentCoordinator = parent
        children.removeAll()
        navigationController?.setViewControllers([], animated: false)
        parent = nil
        return parentCoordinator
    }
}
