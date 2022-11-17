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
        tabBarController.setUpCenterButton()
    }

    // tabBar 내 navigation 이동 시 숨김 or 표시
    func tabBarWillHide(_ visible: Bool) {
        tabBarController.tabBar.isHidden = visible
    }

    // 캡슐 추가 화면으로
    func moveToCapsuleAdd() {
        let capsuleAddCoordinator = CapsuleAddCoordinator()
        capsuleAddCoordinator.parent = self
        capsuleAddCoordinator.start()

        children.append(capsuleAddCoordinator)

        if let controller = capsuleAddCoordinator.navigationController {
            controller.modalPresentationStyle = .fullScreen
            tabBarController.present(controller, animated: true)
        }
    }
}

// TabBar Item 들 생성
private extension TabBarCoordinator {
    func firstTabBarItem() {
        let homeItem = UITabBarItem(title: "홈", image: .homeFill, tag: 0)
        let homeCoordinator = HomeCoordinator()
        homeCoordinator.parent = self
        homeCoordinator.start()
        homeCoordinator.navigationController?.tabBarItem = homeItem

        children.append(homeCoordinator)
    }

    func secondTabBarItem() {
        let capsuleMapItem = UITabBarItem(title: "지도", image: .mapFill, tag: 1)
        let capsuleMapCoordinator = CapsuleMapCoordinator()
        capsuleMapCoordinator.parent = self
        capsuleMapCoordinator.start()
        capsuleMapCoordinator.navigationController?.tabBarItem = capsuleMapItem

        children.append(capsuleMapCoordinator)
    }

    func thirdTabBarItem() {
        let capsuleListItem = UITabBarItem(title: "목록", image: .gridFill, tag: 2)
        let capsuleListCoordinator = CapsuleListCoordinator()
        capsuleListCoordinator.parent = self
        capsuleListCoordinator.start()
        capsuleListCoordinator.navigationController?.tabBarItem = capsuleListItem

        children.append(capsuleListCoordinator)
    }

    func fourthTabBarItem() {
        let profileItem = UITabBarItem(title: "프로필", image: .profileFill, tag: 3)
        let profileCoordinator = ProfileCoordinator()
        profileCoordinator.parent = self
        profileCoordinator.start()
        profileCoordinator.navigationController?.tabBarItem = profileItem

        children.append(profileCoordinator)
    }
}
