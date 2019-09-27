//
//  MainTabBarController.swift
//  SingaporeProject
//
//  Created by 塗木冴 on 2019/09/27.
//  Copyright © 2019 塗木冴. All rights reserved.
//

import UIKit
import RxSwift

class MainTabBarController: UITabBarController {

    typealias Tab = (defaultImge: UIImage?, focusImage: UIImage?, title: String)

    enum TabType: String {
        case arAdmin = "ARAdmin"
        case arGuest = "ARGuest"
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        tabBar.isTranslucent = false
        tabBar.barTintColor = .white
        self.delegate = self
        setViewControllers(createViewControllers(), animated: true)

        navigationController?.setNavigationBarHidden(true, animated: false)
    }

    // MARK: - fileprivate method
    fileprivate func createViewControllers() -> [UIViewController] {

        let arAdminViewController = R.storyboard.arAdmin.instantiateInitialViewController()!
        let arGuestViewController = R.storyboard.arGuest.instantiateInitialViewController()!

        let arAdmninNVC = createFirstViewController(arAdminViewController)
        arAdmninNVC.tabBarItem = createTabBarItem(tabData: createImagePair(tabType: .arAdmin))

        let arGuestNVC = createFirstViewController(arGuestViewController)
        arGuestNVC.tabBarItem = createTabBarItem(tabData: createImagePair(tabType: .arGuest))

        return [arAdmninNVC, arGuestNVC]
    }

    fileprivate func createTabBarItem(tabData: Tab) -> UITabBarItem {

        let tabBarItem = UITabBarItem(title: tabData.title, image: tabData.defaultImge?.withRenderingMode(.alwaysOriginal), selectedImage: tabData.focusImage?.withRenderingMode(.alwaysOriginal))
        tabBarItem.titlePositionAdjustment = UIOffset(horizontal: 0, vertical: 4)
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor(red: 165/255, green: 165/255, blue: 165/255, alpha: 1.0)], for: .normal)
        tabBarItem.setTitleTextAttributes([NSAttributedString.Key.font: UIFont.systemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor(red: 65/255, green: 105/255, blue: 225/255, alpha: 1.0)], for: .selected)

        return tabBarItem
    }

    fileprivate func createImagePair(tabType: TabType) -> Tab {

        switch tabType {
        case .arAdmin:
            return (R.image.icon_sample_white(), R.image.icon_sample_color(), tabType.rawValue)
        case .arGuest:
            return (R.image.icon_sample_white(), R.image.icon_sample_color(), tabType.rawValue)
        }
    }

    func createFirstViewController(_ viewController: UIViewController) -> UINavigationController {
        let navigationController = UINavigationController()
        navigationController.view.backgroundColor = .white
        let firstViewController = viewController
        navigationController.viewControllers = [firstViewController]
        navigationController.setNavigationBarHidden(true, animated: false)
        return navigationController
    }
}
extension MainTabBarController: UITabBarControllerDelegate {

    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return true

    }

    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
    }

}
