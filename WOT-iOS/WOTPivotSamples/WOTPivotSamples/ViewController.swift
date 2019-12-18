//
//  ViewController.swift
//  WOTPivotSamples
//
//  Created by Pavel Yeshchyk on 6/5/19.
//  Copyright © 2019 Pavel Yeshchyk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }


    @IBAction func pushSteelPivot(_ sender: Any?) {
         let storyBoard = UIStoryboard(name: "Main", bundle: Bundle(for: SteelPivotViewController.self))
        let vc = storyBoard.instantiateViewController(withIdentifier: "SteelPivotViewController")
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

