//
//  AvisoCarritoViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 9/08/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class AvisoCarritoViewController: UIViewController
{
    @IBOutlet var btnEntendido: UIButton!
    @IBOutlet var btnOmitir: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        btnEntendido.layer.cornerRadius = 10.0
        btnOmitir.layer.cornerRadius = 10.0
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
