//
//  DPRouterNavigationController.swift
//  DPCore
//
//  Created by Farshad Mousalou on 2/5/19.
//  Copyright © 2019 DigiPay. All rights reserved.
//

import UIKit

internal class DPRouterNavigationController: UINavigationController {

    private let id = UUID()
    
    var identifier: UUID {
        return id
    }
    
    override func loadView() {
        super.loadView()
        FontLoader.loadFontIfNeeded()
        if UI_USER_INTERFACE_IDIOM() == .pad {
            self.modalPresentationStyle = .formSheet
            self.preferredContentSize = CGSize(width: 375, height: 548+64)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.semanticContentAttribute = .forceRightToLeft
        
        self.view.setNeedsDisplay()
        self.view.setNeedsLayout()
        self.navigationBar.semanticContentAttribute = .forceRightToLeft
        self.navigationBar.isTranslucent = false
        
        self.navigationBar.titleTextAttributes = [NSAttributedStringKey.font: UIFont(name: "IRANYekan-Light", size: 18)!]
        
        if UI_USER_INTERFACE_IDIOM() == .pad {
            self.modalPresentationStyle = .formSheet
            self.preferredContentSize = CGSize(width: 375, height: 548+64)
        }
        
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

}
