//
//  DireccionesViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 23/09/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class DireccionesViewController: UIViewController
{
    @IBOutlet var barFixedSpace: UIBarButtonItem!
    
    @IBAction func backView(_ sender: Any)
    {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if DeviceType.IS_IPHONE_5
        {
            barFixedSpace.width = 45.0
        }
        
        if DeviceType.IS_IPHONE_6P
        {
            barFixedSpace.width = 70.0
        }
    }

    override func didReceiveMemoryWarning()
    {
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
