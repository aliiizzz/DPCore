//
//  DPBaseViewController.swift
//  DPCore
//
//  Created by Farshad Mousalou on 11/15/18.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import UIKit

class DPBaseViewController: UIViewController {
    
    private let id: UUID = UUID()
    
    var identifier: UUID {
        return id
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

//    override var shouldAutorotate: Bool {
//        return true
//    }
//
//    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
//
//        switch UI_USER_INTERFACE_IDIOM() {
//        case .pad:
//            return .all
//        default:
//            return [.portrait, .portraitUpsideDown]
//        }
//
//    }
//
//    override var preferredStatusBarStyle: UIStatusBarStyle {
//        return .lightContent
//    }
    
}
