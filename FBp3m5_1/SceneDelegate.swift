//
//  SceneDelegate.swift
//  FBp3m5_1
//
//  Created by Amina TomasMart on 21.03.2024.
//

import UIKit

protocol SceneRoutingDelegate {
    func vcRouting(vc: UIViewController)
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate, SceneRoutingDelegate {

    var window: UIWindow?
    private let service = Service()
    private var vc: UIViewController?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }
        let window = UIWindow(windowScene: scene)
        if service.checkAuth() {
            vc = ViewController()
        } else {
            let authVC = AuthViewController()
            authVC.delegate = self
            vc = AuthViewController()
        }
        window.rootViewController = UINavigationController(rootViewController: vc!)
        window.makeKeyAndVisible()
        self.window = window
    }
    
    func vcRouting(vc: UIViewController) {
        window?.rootViewController = UINavigationController(rootViewController: vc)
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

