//
//  DireccionesViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 23/09/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit
import FirebaseAuth

class DireccionesViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let modelUsuario = ModeloUsuario.sharedInstance
    let  user = FIRAuth.auth()?.currentUser
    
    @IBOutlet var barFixedSpace: UIBarButtonItem!
    @IBOutlet var tableDireccionesUsuario: UITableView!
    @IBOutlet var btnCrearDireccion: UIButton!
    @IBOutlet var lblCrearDireccion: UILabel!
    
    @IBAction func backView(_ sender: Any)
    {
        let transition = CATransition()
        transition.duration = 0.3
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        view.window!.layer.add(transition, forKey: kCATransition)
        
        dismiss(animated: false, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if DeviceType.IS_IPHONE_5
        {
            barFixedSpace.width = 70.0
        }
        
        if DeviceType.IS_IPHONE_6P
        {
            barFixedSpace.width = 115.0
        }
        
        if modelUsuario.usuario[0].datosComplementarios?[0].direcciones?.count == 3
        {
            btnCrearDireccion.isHidden = true
            lblCrearDireccion.isHidden = true
        }else
        {
            btnCrearDireccion.isHidden = false
            lblCrearDireccion.isHidden = false
        }
        
        let nib = UINib(nibName: "DireccionTableViewCell", bundle: nil)
        tableDireccionesUsuario.register(nib, forCellReuseIdentifier: "direccionTableViewCell")
        tableDireccionesUsuario.reloadData()
    }
    
    @objc func refrescarVista(_ notification: Notification)
    {
        if modelUsuario.usuario[0].datosComplementarios?[0].direcciones?.count == 3
        {
            btnCrearDireccion.isHidden = true
            lblCrearDireccion.isHidden = true
        }else
        {
            btnCrearDireccion.isHidden = false
            lblCrearDireccion.isHidden = false
        }
        
        tableDireccionesUsuario.reloadData()
    }
    
    // #pragma mark - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return (modelUsuario.usuario[0].datosComplementarios?[0].direcciones?.count)!
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "direccionTableViewCell")  as! DireccionTableViewCell
        
        cell.lblNombreDireccion.text = modelUsuario.usuario[0].datosComplementarios?[0].direcciones?[indexPath.row].nombre
        cell.lblDireccion.text = modelUsuario.usuario[0].datosComplementarios?[0].direcciones?[indexPath.row].direccion
        
        cell.swEstadoDireccion.tag = indexPath.row
        cell.swEstadoDireccion .addTarget(self, action: #selector(DireccionesViewController.stateChanged(_:)), for: .valueChanged)
        cell.swEstadoDireccion.setOn((modelUsuario.usuario[0].datosComplementarios?[0].direcciones?[indexPath.row].porDefecto)!, animated: true)
        
        return cell
    }
    
    @objc func stateChanged(_ sender: UISwitch)
    {
        if (modelUsuario.usuario[0].datosComplementarios?[0].direcciones?[sender.tag].porDefecto)!
        {
            tableDireccionesUsuario.reloadData()
            self.mostrarAlerta(titulo: "Advertencia", mensaje: "Esta dirección ya se encuentra como principal")
        } else
        {
            ComandoUsuario.activarDireccion(uid: (user?.uid)!, idDireccion: modelUsuario.usuario[0].datosComplementarios?[0].direcciones?[sender.tag].idDireccion, datos: (modelUsuario.usuario[0].datosComplementarios?[0])!)
            
            ComandoUsuario.getUsuario(uid: (user?.uid)!)
            
            NotificationCenter.default.addObserver(self, selector: #selector(DireccionesViewController.refrescarVista(_:)), name:NSNotification.Name(rawValue:"cargoUsuario"), object: nil)
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        irEdicionPerfil()
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 85
    }
    
    @IBAction func crearNuevaDireccion(_ sender: Any)
    {
        irEdicionPerfil()
    }
    
    func irEdicionPerfil()
    {
        modelUsuario.registroComplementario = (modelUsuario.usuario[0].datosComplementarios?[0])!
        
        for direccion in (modelUsuario.usuario[0].datosComplementarios?[0].direcciones)!
        {
            if direccion.posicion == 1
            {
                modelUsuario.direccion1 = direccion
                modelUsuario.ubicacion1 = (direccion.ubicacion?[0])!
            }
            
            if direccion.posicion == 2
            {
                modelUsuario.direccion2 = direccion
                modelUsuario.ubicacion2 = (direccion.ubicacion?[0])!
            }
            
            if direccion.posicion == 3
            {
                modelUsuario.direccion3 = direccion
                modelUsuario.ubicacion3 = (direccion.ubicacion?[0])!
            }
        }
        
        self.performSegue(withIdentifier: "editarPerfilUsuarioDesdeConfirmacionDos", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(DireccionesViewController.refrescarVista(_:)), name:NSNotification.Name(rawValue:"cargoUsuario"), object: nil)
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
        
        if (segue.identifier == "editarPerfilUsuarioDesdeConfirmacionDos")
        {
            let detailController = segue.destination as! RegistroUsuarioDosViewController
            detailController.datosEditables = true
        }
    }
    
    func mostrarAlerta(titulo:String, mensaje:String)
    {
        let alerta = UIAlertController(title: titulo, message: mensaje, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            return
        }
        
        alerta.addAction(OKAction)
        present(alerta, animated: true, completion: { return })
    }
}
