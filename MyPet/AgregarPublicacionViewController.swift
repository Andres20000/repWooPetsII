//
//  AgregarPublicacionViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 10/05/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class AgregarPublicacionViewController: UIViewController
{
    let model = ModeloOferente.sharedInstance
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
    }

    func presentViewController()
    {
        model.horarioSemana.dias = ""
        model.horarioFestivo.dias = ""
        model.oferente.removeAll()
        
        model.publicacion.activo = false
        model.publicacion.categoria = ""
        model.publicacion.descripcion = ""
        model.publicacion.destacado = false
        model.publicacion.fotos?.removeAll()
        model.publicacion.horario?.removeAll()
        model.publicacion.idOferente = ""
        model.publicacion.idPublicacion = ""
        model.publicacion.nombre = ""
        model.publicacion.precio = ""
        model.publicacion.servicio = false
        model.publicacion.stock = 0
        model.publicacion.subcategoria = ""
        model.publicacion.target = ""
        
        self.performSegue(withIdentifier: "publicarDesdeElHomeOferente", sender: self)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        perform(#selector(presentViewController), with: nil, afterDelay: 0)
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
