//
//  DetalleVenta.swift
//  MyPet
//
//  Created by Andres Garcia on 8/17/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class DetalleVenta: UIViewController {

   
    
    @IBOutlet weak var viewServicio: UIView!
    
    @IBOutlet weak var viewProducto: UIView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //viewServicio.isHidden = true

        // Do any additional setup after loading the view.
    }
    
    
    @IBAction func backView(_ sender: Any)
    {
        let transition = CATransition()
        transition.duration = 0.4
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

   }
