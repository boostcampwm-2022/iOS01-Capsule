//
//  TabBarCoordinator.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit

final class TabBarCoordinator: Coordinator {
    var parent: Coordinator?
    var children: [Coordinator] = []
    var navigationController: UINavigationController?
    var tabBarController: CustomTabBarController

    init(tabBarController: CustomTabBarController) {
        self.tabBarController = tabBarController
    }

    func start() {
        firstTabBarItem()
        secondTabBarItem()
        thirdTabBarItem()
        fourthTabBarItem()

        tabBarController.viewControllers = children.compactMap { $0.navigationController }
    }

    private func firstTabBarItem() {
        let homeItem = UITabBarItem(title: "홈", image: .homeFill, tag: 0)
        let homeCoordinator = HomeCoordinator()

        children.append(homeCoordinator)
        homeCoordinator.parent = self
        homeCoordinator.start()
        homeCoordinator.navigationController?.tabBarItem = homeItem
    }

    private func secondTabBarItem() {
        let capsuleMapItem = UITabBarItem(title: "지도", image: .mapFill, tag: 1)
        capsuleMapItem.standardAppearance?.backgroundColor = .red
        let capsuleMapCoordinator = CapsuleMapCoordinator()

        children.append(capsuleMapCoordinator)
        capsuleMapCoordinator.parent = self
        capsuleMapCoordinator.start()
        capsuleMapCoordinator.navigationController?.tabBarItem = capsuleMapItem
    }

    private func thirdTabBarItem() {
        let capsuleListItem = UITabBarItem(title: "목록", image: .gridFill, tag: 2)
        let capsuleListCoordinator = CapsuleListCoordinator()

        children.append(capsuleListCoordinator)
        capsuleListCoordinator.parent = self
        capsuleListCoordinator.start()
        capsuleListCoordinator.navigationController?.tabBarItem = capsuleListItem
    }

    private func fourthTabBarItem() {
        let profileItem = UITabBarItem(title: "프로필", image: .profileFill, tag: 3)
        let profileCoordinator = ProfileCoordinator()

        children.append(profileCoordinator)
        profileCoordinator.parent = self
        profileCoordinator.start()
        profileCoordinator.navigationController?.tabBarItem = profileItem
    }
}
