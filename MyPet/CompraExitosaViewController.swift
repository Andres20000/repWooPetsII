//
//  CompraExitosaViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 17/08/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class CompraExitosaViewController: UIViewController
{
    @IBOutlet var btnContinuar: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        btnContinuar.layer.cornerRadius = 10.0
    }
    
    @IBAction func continuar(_ sender: Any)
    {
        self.performSegue(withIdentifier: "precargarPublicacionesDesdeCompraExitosa", sender: self)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if (segue.identifier == "precargarPublicacionesDesdeCompraExitosa")
        {
            let detailController = segue.destination as! PreCargaDatosViewController
            detailController.omitir = false
        }
    }

}