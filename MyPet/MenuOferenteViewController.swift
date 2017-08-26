//
//  MenuOferenteViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 10/05/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit
import FirebaseAuth

class MenuOferenteViewController: UIViewController
{
    let  user = FIRAuth.auth()?.currentUser
    
    var model  = ModeloOferente.sharedInstance
    
    @IBOutlet var lblRazonSocial: UILabel!
    
    @IBOutlet weak var numeroPreguntas: UILabel!
    
    @IBOutlet weak var circuloRojo: UIImageView!
    
    
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
        
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.repintarXPregunta), name:NSNotification.Name(rawValue:"cargoPregunta"), object: nil)
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        refrescarPreguntas()
    }
    
    
    func refrescarPreguntas() {
        let preguntas = model.numeroPreguntasSinRespuesta()
        if   preguntas == 0 {
            circuloRojo.isHidden = true
        }
        else {
            circuloRojo.isHidden = false
            numeroPreguntas.text = String(preguntas)
        }
        
        
    }
    
    
    func cargarDatosOferente(_ notification: Notification)
    {
        lblRazonSocial.text = "   " + model.oferente[0].razonSocial!
    }
    
    @IBAction func navegarMenu(_ sender: Any)
    {
        let btnMenu:UIButton = sender as! UIButton
        
        switch btnMenu.tag
        {
        case 1:
            
            model.horarioSemana.dias = ""
            model.horarioFestivo.dias = ""
            model.oferente.removeAll()
            
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            view.window!.layer.add(transition, forKey: kCATransition)
            
            self.performSegue(withIdentifier: "misPublicaciones", sender: self)
            
        case 2:
            self.performSegue(withIdentifier: "misPreguntas", sender: self)

            
        case 3:
            //self.performSegue(withIdentifier: "misPublicaciones", sender: self)
            print("En construcción")
            
        case 4:
            self.performSegue(withIdentifier: "misVentas", sender: self)
            print("En construcción")
            
        case 5:
            
            let transition = CATransition()
            transition.duration = 0.5
            transition.type = kCATransitionPush
            transition.subtype = kCATransitionFromRight
            view.window!.layer.add(transition, forKey: kCATransition)
            
            self.performSegue(withIdentifier: "editarOferente", sender: self)
            
        case 6:
            //self.performSegue(withIdentifier: "misPublicaciones", sender: self)
            print("En construcción")
            
        case 7:
            
            let alert:UIAlertController = UIAlertController(title: "¡Atención!", message: "¿Seguro deseas cerrar sesión?", preferredStyle: .alert)
            
            let cerrarAction = UIAlertAction(title: "Sí, cerrar", style: .default)
            {
                UIAlertAction in self.cerrarSesion()
            }
            
            let cancelAction = UIAlertAction(title: "No, cancelar", style: .cancel)
            {
                UIAlertAction in
            }
            
            // Add the actions
            alert.addAction(cerrarAction)
            alert.addAction(cancelAction)
            self.present(alert, animated: true, completion: nil)
            
        default:
            print("Nothing")
        }
    }
    
    func cerrarSesion()
    {
        model.horarioSemana.dias = ""
        model.horarioFestivo.dias = ""
        model.oferente.removeAll()
        
        try! FIRAuth.auth()!.signOut()
        
        performSegue(withIdentifier: "ingresoDesdeHomeOferente", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        ComandoOferente.getOferente(uid: (user?.uid)!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MenuOferenteViewController.cargarDatosOferente(_:)), name:NSNotification.Name(rawValue:"cargoOferente"), object: nil)
    }
    
    override func didReceiveMemoryWarning()
    {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    func repintarXPregunta(){
        refrescarPreguntas()
        
    }
    
    
}
