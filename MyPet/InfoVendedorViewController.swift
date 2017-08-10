//
//  InfoVendedorViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 27/07/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class InfoVendedorViewController: UIViewController
{
    let modelOferente = ModeloOferente.sharedInstance
    
    @IBOutlet var lblNombre: UILabel!
    @IBOutlet var lblDireccion: UILabel!
    @IBOutlet var lblTelefono: UILabel!
    @IBOutlet var lblCelular: UILabel!
    @IBOutlet var lblWeb: UILabel!
    @IBOutlet var lblCorreo: UILabel!
    
    @IBAction func backView(_ sender: Any)
    {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lblNombre.text = modelOferente.oferente[0].razonSocial
        lblDireccion.text = modelOferente.oferente[0].direccion
        lblTelefono.text = modelOferente.oferente[0].telefono
        lblCelular.text = modelOferente.oferente[0].celular
        
        if modelOferente.oferente[0].paginaWeb != ""
        {
            lblWeb.text = modelOferente.oferente[0].paginaWeb
        }
        
        lblCorreo.text = modelOferente.oferente[0].correo
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
