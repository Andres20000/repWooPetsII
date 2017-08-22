//
//  CompraExitosaViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 17/08/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit
import FirebaseAuth

class CompraExitosaViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let  user = FIRAuth.auth()?.currentUser
    
    let modelUsuario = ModeloUsuario.sharedInstance
    let modelOferente = ModeloOferente.sharedInstance
    
    @IBOutlet var tableCompras: UITableView!
    @IBOutlet var btnContinuar: UIButton!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        btnContinuar.layer.cornerRadius = 10.0
        
        let nib = UINib(nibName: "ProductoCompradoTableViewCell", bundle: nil)
        tableCompras.register(nib, forCellReuseIdentifier: "productoCompradoTableViewCell")
        
        let nib2 = UINib(nibName: "ServicioCompradoTableViewCell", bundle: nil)
        tableCompras.register(nib2, forCellReuseIdentifier: "servicioCompradoTableViewCell")
    }
    
    func refrescarVista(_ notification: Notification)
    {
        tableCompras.reloadData()
    }
    
    // #pragma mark - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        if modelUsuario.publicacionCarrito.publicacionCompra.servicio!
        {
            let cell = tableView.dequeueReusableCell(withIdentifier: "servicioCompradoTableViewCell")  as! ServicioCompradoTableViewCell
            
            cell.lblNombrePublicacion.text = modelUsuario.compra.pedido?[0].publicacionCompra.nombre
            cell.lblCantidad.text = "\((modelUsuario.compra.pedido?[0].cantidadCompra)!)"
            cell.lblTextoFecha.text = "Se hará efectivo:"
            cell.lblFecha.text = modelUsuario.compra.pedido?[0].fechaServicio
            cell.lblDireccion.text = modelOferente.oferente[0].direccion
            cell.lblTelefono.text = modelOferente.oferente[0].telefono
            
            let TotalString:String = String(modelUsuario.compra.valor!)
            cell.lblTotal.text = TotalString
            
            if let amountString = cell.lblTotal.text?.currencyInputFormatting()
            {
                cell.lblTotal.text = amountString
            }
            
            return cell
        }
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "productoCompradoTableViewCell")  as! ProductoCompradoTableViewCell
        
        cell.lblNombrePublicacion.text = modelUsuario.compra.pedido?[0].publicacionCompra.nombre
        cell.lblCantidad.text = "\((modelUsuario.compra.pedido?[0].cantidadCompra)!)"
        cell.lblTextoEntrega.text = "Llegará en XX días a:"
        
        for direccionEntrega in (modelUsuario.usuario[0].datosComplementarios?[0].direcciones)!
        {
            if direccionEntrega.porDefecto!
            {
                cell.lblDireccion.text = direccionEntrega.direccion
            }
        }
        
        cell.lblTelefono.text = modelUsuario.usuario[0].datosComplementarios?[0].celular
        
        let TotalString:String = String(modelUsuario.compra.valor!)
        cell.lblTotal.text = TotalString
        
        if let amountString = cell.lblTotal.text?.currencyInputFormatting()
        {
            cell.lblTotal.text = amountString
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("Seleccionado")
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        if modelUsuario.publicacionCarrito.publicacionCompra.servicio!
        {
            return 130
        }
        
        return 110
    }
    
    @IBAction func continuar(_ sender: Any)
    {
        modelUsuario.publicacionCarrito.idCarrito = ""
        
        ComandoUsuario.getUsuario(uid: (user?.uid)!)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CompraExitosaViewController.irAPrecargar(_:)), name:NSNotification.Name(rawValue:"cargoUsuario"), object: nil)
    }
    
    func irAPrecargar(_ notification: Notification)
    {
        self.performSegue(withIdentifier: "precargarPublicacionesDesdeCompraExitosa", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CompraExitosaViewController.refrescarVista(_:)), name:NSNotification.Name(rawValue:"cargoOferente"), object: nil)
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
