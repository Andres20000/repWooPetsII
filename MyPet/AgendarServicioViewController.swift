//
//  AgendarServicioViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 3/08/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit
import FirebaseAuth

class AgendarServicioViewController: UIViewController
{
    let modelUsuario = ModeloUsuario.sharedInstance
    let  user = Auth.auth().currentUser
    
    @IBOutlet var lblDuracion: UILabel!
    
    @IBOutlet var datePicker : UIDatePicker!
    
    @IBOutlet var btnAceptar: UIButton!
    @IBOutlet var btnCancelar: UIButton!
    
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
        
        btnAceptar.layer.cornerRadius = 10.0
        
        btnCancelar.layer.cornerRadius = 10.0
        
        datePicker.minimumDate = Date()
        
        if modelUsuario.publicacionCarrito.fechaHoraReserva != ""
        {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd/MM/yyyy h:mm a"
            let dateReserva = dateFormatter.date(from: modelUsuario.publicacionCarrito.fechaHoraReserva!)
            
            datePicker.date = dateReserva!
        }
    }
    
    @IBAction func aceptarFechaAgendada(_ sender: Any)
    {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy h:mm a"
        let dateString = dateFormatter.string(from: datePicker.date)
        
        modelUsuario.publicacionCarrito.fechaHoraReserva = dateString
        
        if modelUsuario.publicacionCarrito.idCarrito != ""
        {
            ComandoUsuario.editarPublicacionCarrito(uid: (user?.uid)!, carrito: modelUsuario.publicacionCarrito)
        }
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: true, completion: nil)
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
