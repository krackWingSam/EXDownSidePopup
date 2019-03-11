//
//  ViewController.swift
//  EXDownSidePopup
//
//  Created by 강상우 on 11/03/2019.
//  Copyright © 2019 강상우. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var contentView1: UIView!
    @IBOutlet weak var contentView2: UIView!
    
    var testView1: EXDownSidePopup!
    var testView2: EXDownSidePopup!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        testView1 = EXDownSidePopup.getPopup(with: contentView1, superView: self.view, popupKind: .EXDownSidePopupExtension)
        testView2 = EXDownSidePopup.getPopup(with: contentView2, superView: self.view, popupKind: .EXDownSidePopupCancle)
        print()
    }

    
    //MARK: - IBActions
    @IBAction func action_Button(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            testView2.hide()
            testView1.show()
            break
            
        case 2:
            testView1.hide()
            testView2.show()
            break
            
        default: break
        }
    }
    
    @IBAction func action_Cancel(_: UIButton) {
        testView1.hide()
        testView2.hide()
    }
}

