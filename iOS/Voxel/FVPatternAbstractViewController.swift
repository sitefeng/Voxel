//
//  FVPatternAbstractViewController.swift
//  Voxel
//
//  Created by Si Te Feng on 1/17/16.
//  Copyright © 2016 Si Te Feng. All rights reserved.
//

import UIKit

class FVPatternAbstractViewController: HNAbstractViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let dismissBarButton = UIBarButtonItem(title: "Dismiss", style: UIBarButtonItemStyle.Done, target: self, action: "dismissButtonPressed")
        self.navigationItem.leftBarButtonItem = dismissBarButton
        
        let sendBarButton = UIBarButtonItem(title: "Send", style: UIBarButtonItemStyle.Done, target: self, action: "sendButtonPressed")
        self.navigationItem.rightBarButtonItem = sendBarButton
    }
    
    func dismissButtonPressed() {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    func sendButtonPressed() {
        assertionFailure("Must Implement Concrete Method")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
