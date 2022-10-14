//
//  Apple Media Content Manager.swift
//  Manage_My_Playlists
//
//  Created by Aisultan Askarov on 13.10.2022.
//

import Foundation
import UIKit
import MediaPlayer
import MusicKit
import StoreKit

class Media_Content_Manager {
    
    static let shared = Media_Content_Manager()
    let mediaServiceController = SKCloudServiceController()
    
    private init() {}
    
    func checkIfAppleMusicIsAvailable(onCompletion: @escaping (MediaRequestResultReferences?) -> Void) {
                
        if SKCloudServiceController.authorizationStatus() == .authorized {
            
//            mediaServiceController.requestCapabilities { capabilities, error in
//                DispatchQueue.global(qos: .background).async {
//                    if capabilities.contains(.musicCatalogPlayback) {
//                        // User has Apple Music account
//                        print("fe")
//
//                    }
//
//                    else if capabilities.contains(.musicCatalogSubscriptionEligible) {
//                        // User can sign up to Apple Music
//
//
//                    }
//                }
//            }
            
            onCompletion(.authorized)
            
        } else if SKCloudServiceController.authorizationStatus() == .denied {
            
            onCompletion(.denied)
            
        } else if SKCloudServiceController.authorizationStatus() == .notDetermined {
            
//            SKCloudServiceController.requestAuthorization { _ in
//
//            }
            onCompletion(.notDetermined)
            
        } else if SKCloudServiceController.authorizationStatus() == .restricted {
            
            onCompletion(.restricted)
            
        }
        
    }
    
//    func showAppleMusicSignup(viewController: UIViewController) {
//
//        let vc = SKCloudServiceSetupViewController()
//        vc.delegate = viewController as! any SKCloudServiceSetupViewControllerDelegate
//
//        let options: [SKCloudServiceSetupOptionsKey: Any] = [.action: SKCloudServiceSetupAction.subscribe, .messageIdentifier: SKCloudServiceSetupMessageIdentifier.playMusic]
//
//        vc.load(options: options) { success, error in
//            if success {
//                viewController.present(vc, animated: true)
//            }
//        }
//
//    }
    
}
