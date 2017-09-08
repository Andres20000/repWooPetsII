//
//  PagoExitosoDestacado.swift
//  MyPet
//
//  Created by Andres Garcia on 9/7/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class PagoExitosoDestacado: UIViewController {

    
    
    @IBOutlet weak var valor: UILabel!
    @IBOutlet weak var impresiones: UILabel!
    let model = ModeloOferente.sharedInstance
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
        
        valor.text = String(model.params.valorDestacado).convertToMoney()
        impresiones.text = "por " + String(model.params.impresionesDestacado) +  " impresiones (visualizaciones totales de los usuarios) al mes."
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
    
}
