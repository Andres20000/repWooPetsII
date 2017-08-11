//
//  ConfirmacionDosViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 10/08/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class ConfirmacionDosViewController: UIViewController
{
    @IBOutlet var lblNombreCompleto: UILabel!
    @IBOutlet var lblCedula: UILabel!
    @IBOutlet var lblDireccion: UILabel!
    @IBOutlet var lblTelefono: UILabel!
    @IBOutlet var lblMetodoPago: UILabel!
    @IBOutlet var lblTotal: UILabel!
    @IBOutlet var btnFinalizar: UIButton!
    
    @IBAction func backView(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lblNombreCompleto.layer.masksToBounds = true
        lblNombreCompleto.layer.cornerRadius = 7.0
        
        lblCedula.layer.masksToBounds = true
        lblCedula.layer.cornerRadius = 7.0
        
        lblTelefono.layer.masksToBounds = true
        lblTelefono.layer.cornerRadius = 7.0
        
        btnFinalizar.layer.cornerRadius = 10.0
    }
    
    @IBAction func finalizarCompra(_ sender: Any)
    {
        //self.performSegue(withIdentifier: "confirmacionDosDesdeConfirmacionUno", sender: self)
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
