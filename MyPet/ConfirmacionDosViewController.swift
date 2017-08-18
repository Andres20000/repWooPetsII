//
//  ConfirmacionDosViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 10/08/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit
import FirebaseAuth

class ConfirmacionDosViewController: UIViewController
{
    let modelUsuario = ModeloUsuario.sharedInstance
    let  user = FIRAuth.auth()?.currentUser
    
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
        
        let costo:Int = Int(modelUsuario.publicacionCarrito.publicacionCompra.precio!)!
        let Total:Int = modelUsuario.publicacionCarrito.cantidadCompra! * costo
        let TotalString:String = String(Total)
        lblTotal.text = TotalString
        
        if let amountString = lblTotal.text?.currencyInputFormatting()
        {
            lblTotal.text = amountString
        }
    }
    
    @IBAction func finalizarCompra(_ sender: Any)
    {
        let nowDate = NSDate()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy h:mm a"
        let dateString = dateFormatter.string(from: nowDate as Date)
        
        modelUsuario.compra.fecha = dateString
        
        modelUsuario.compra.idCliente = (user?.uid)!
        modelUsuario.compra.idOferente = modelUsuario.publicacionCarrito.publicacionCompra.idOferente
        
        let pedido = PedidoUsuario()
        
        pedido.cantidadCompra = modelUsuario.publicacionCarrito.cantidadCompra
        pedido.estado = "abierta"
        
        if modelUsuario.publicacionCarrito.publicacionCompra.servicio!
        {
            pedido.fechaServicio = modelUsuario.publicacionCarrito.fechaHoraReserva
        }
        
        pedido.idPublicacion = modelUsuario.publicacionCarrito.publicacionCompra.idPublicacion
        pedido.servicio = modelUsuario.publicacionCarrito.publicacionCompra.servicio
        
        modelUsuario.compra.pedido?.append(pedido)
        
        let costo:Int = Int(modelUsuario.publicacionCarrito.publicacionCompra.precio!)!
        let Total:Int = modelUsuario.publicacionCarrito.cantidadCompra! * costo
        
        modelUsuario.compra.valor = Total
        
        self.performSegue(withIdentifier: "compraExitosaDesdeConfirmacionDos", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        lblNombreCompleto.text = "   \((modelUsuario.usuario[0].datosComplementarios?[0].nombre)!) \((modelUsuario.usuario[0].datosComplementarios?[0].apellido)!)"
        
        lblCedula.text = "   \((modelUsuario.usuario[0].datosComplementarios?[0].documento)!)"
        
        for direccion in (modelUsuario.usuario[0].datosComplementarios?[0].direcciones)!
        {
            if direccion.porDefecto!
            {
                lblDireccion.text = "   \(direccion.direccion!)"
            }
        }
        
        lblTelefono.text = "   \((modelUsuario.usuario[0].datosComplementarios?[0].celular)!)"
        
        if (modelUsuario.usuario[0].datosComplementarios?[0].pagoEfectvo)!
        {
            lblMetodoPago.text = "   Efectivo"
        } else
        {
            lblMetodoPago.text = "   Tarjeta"
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
