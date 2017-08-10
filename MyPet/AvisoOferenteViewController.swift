//
//  AvisoOferenteViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 25/04/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class AvisoOferenteViewController: UIViewController
{
    // This constraint ties an element at zero points from the top layout guide
    @IBOutlet var spaceTopLayoutConstraint: NSLayoutConstraint?
    
    @IBOutlet var lblAviso: UILabel!
    @IBOutlet var btnContinuar: UIButton!
    @IBOutlet var btnTerminosCondiciones: UIButton!

    @IBAction func backView(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func registrarOferente(_ sender: Any)
    {
        let alert:UIAlertController = UIAlertController(title: "¡Recuerda!", message: "Para hacer parte de WooPets, debes tener servicio de domicilio.\n¿Actualmente cuentas o puedes ofrecer este servicio?", preferredStyle: .alert)
        
        let continuarAction = UIAlertAction(title: "Sí, Continuar", style: .default)
        {
            UIAlertAction in self.continuarRegistro()
        }
        
        let cancelAction = UIAlertAction(title: "No, Cancelar", style: .cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        alert.addAction(continuarAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func continuarRegistro()
    {
        self.performSegue(withIdentifier: "registroOferente", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        btnContinuar.layer.cornerRadius = 10.0
        
        if DeviceType.IS_IPHONE_5
        {
            self.spaceTopLayoutConstraint?.constant = 20.0
            
            lblAviso.font = UIFont (name: "HelveticaNeue-Light", size: 16.0)
            btnTerminosCondiciones.titleLabel?.font = UIFont (name: "HelveticaNeue-Light", size: 9.0)
            
        } else
        {
            if DeviceType.IS_IPHONE_6P
            {
                lblAviso.font = UIFont (name: "HelveticaNeue-Light", size: 22.0)
                btnTerminosCondiciones.titleLabel?.font = UIFont (name: "HelveticaNeue-Light", size: 14.0)
            }
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
