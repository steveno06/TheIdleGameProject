//
//  SceneDelegate.swift
//  idelGame
//
//  Created by Steven Ohrdorf on 23/1/24.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(frame: windowScene.coordinateSpace.bounds)
        window?.windowScene = windowScene
        window?.rootViewController = ViewController()
        window?.makeKeyAndVisible()
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
        print("disconnect")
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
        do{
            let timers = try context.fetch(TimerStateManager.fetchRequest())
            if timers.isEmpty{
                let newTimer = TimerStateManager(context: context)
                newTimer.timeOfLogOff = Date()
            }
            else{
                // Safely unwrap the optional UIWindow
                if let window = window, let viewController = window.rootViewController as? ViewController {
                    // Call the function in the view controller
                    print("asdasdasd")
                    viewController.getLastLogOff()
                }
            }
        
        }
        catch{
            print("fatal error")
        }
        print("Became Active")
        
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
        do{
            let timers = try context.fetch(TimerStateManager.fetchRequest())
            timers[0].timeOfLogOff = Date()
            try context.save()
        }
        catch{

        }
        
        if let window = window, let viewController = window.rootViewController as? ViewController {
            // Call the function in the view controller
            print("got here in the code")
            viewController.stopTimerBar()
        }
        print("Will move from active to inactive")
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        print("back to foreground")
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        print("Did enter background")

        
        
        
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }


}

