//
//  NicknameViewController.swift
//  SpaceCapsule
//
//  Created by young june Park on 2022/11/15.
//

import UIKit
import FirebaseAuth

final class NicknameViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .red
        
        let user = FirebaseAuth.Auth.auth().currentUser
        
        print(user?.displayName)
        print(user?.metadata)
        print(user?.getIDToken())
        print(user?.refreshToken)
        print(user?.photoURL)
        
    }
    
}
