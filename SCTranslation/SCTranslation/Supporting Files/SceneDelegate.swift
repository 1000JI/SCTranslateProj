//
//  SceneDelegate.swift
//  SCTranslation
//
//  Created by 천지운 on 2020/06/21.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import UIKit
import Firebase

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
  
  var window: UIWindow?
  
  func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
    
    guard let windowScene = (scene as? UIWindowScene) else { return }
    let naviC = UINavigationController(rootViewController: MainVC())
    
    // Use Firebase library to configure APIs
    FirebaseApp.configure()
    
    window = UIWindow(windowScene: windowScene)
    window?.backgroundColor = .systemBackground
    window?.rootViewController = naviC
    window?.frame = UIScreen.main.bounds
    window?.makeKeyAndVisible()
  }
  
}

