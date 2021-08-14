//
//  SceneDelegate.swift
//  TeamSB
//
//  Created by 구본의 on 2021/06/29.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
       
        if UserDefaults.standard.bool(forKey: "autoLoginState") == false {
            let storyBoard = UIStoryboard(name: "Login", bundle: nil)
            let loginVC = storyBoard.instantiateViewController(identifier: "LoginNavigationVC")
            window?.rootViewController = loginVC
            window?.makeKeyAndVisible()

        } else {
            if UserDefaults.standard.bool(forKey: "userNicknameExist") == false {
                let storyBoard = UIStoryboard(name: "Login", bundle: nil)
                let nicknameVC = storyBoard.instantiateViewController(identifier: "NickNameViewController")
                window?.rootViewController = nicknameVC
                window?.makeKeyAndVisible()

            } else {
                let storyBoard = UIStoryboard(name: "Home", bundle: nil)
                let homeVC = storyBoard.instantiateViewController(identifier: "MainVC")
                window?.rootViewController = homeVC
                window?.makeKeyAndVisible()
            }
        }
        
        print("111111111111111111111111")
        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        print("22222222222222222222")
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        print("33333333333333333333")
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        print("444444444444444444444444444")
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        print("55555555")
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        print("66666666666")
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

