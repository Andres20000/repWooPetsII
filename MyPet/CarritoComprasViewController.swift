//
//  CarritoComprasViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 13/06/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit
import FirebaseAuth

class CarritoComprasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let model = Modelo.sharedInstance
    let modelOferente = ModeloOferente.sharedInstance
    let modelUsuario = ModeloUsuario.sharedInstance
    let  user = FIRAuth.auth()?.currentUser
    
    @IBOutlet var segCtrlCarrito: UISegmentedControl!
    
    @IBOutlet var viewMensaje: UIView!
    @IBOutlet var imgMensaje: UIImageView!
    @IBOutlet var lblMensaje: UILabel!
    
    @IBOutlet var tableProductosServicios: UITableView!
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        // Configuración UISegmentedControl
        
        let attributes = [ NSForegroundColorAttributeName : UIColor.white,
                           NSFontAttributeName : UIFont (name: "HelveticaNeue-Light", size: 15.0)];
        let attributesSelected = [ NSForegroundColorAttributeName : UIColor.white,
                                   NSFontAttributeName : UIFont(name: "HelveticaNeue-Medium", size: 15.0)];
        
        UISegmentedControl.appearance().setTitleTextAttributes(attributes as Any as? [AnyHashable : Any], for: .normal)
        UISegmentedControl.appearance().setTitleTextAttributes(attributesSelected as Any as? [AnyHashable : Any], for: .selected)
        
        segCtrlCarrito.clipsToBounds = true
        segCtrlCarrito.layer.cornerRadius = 10.0
        segCtrlCarrito.layer.borderWidth = 1.0
        segCtrlCarrito.layer.borderColor = UIColor.white.cgColor
        
        let nib = UINib(nibName: "FavoritoTableViewCell", bundle: nil)
        tableProductosServicios.register(nib, forCellReuseIdentifier: "favoritoTableViewCell")
        
        let nib2 = UINib(nibName: "CarritoTableViewCell", bundle: nil)
        tableProductosServicios.register(nib2, forCellReuseIdentifier: "carritoTableViewCell")
    }
    
    func refrescarVista(_ notification: Notification)
    {
        switch segCtrlCarrito.selectedSegmentIndex
        {
        case 0:
            
            viewMensaje.isHidden = false
            imgMensaje.image = UIImage(named: "imgCarritoVacio")
            lblMensaje.text = "Actualmente no tienes ningún producto y/o servicio en tu carrito."
            
            if model.publicacionesEnCarrito.count != 0
            {
                viewMensaje.isHidden = true
            }
            
        case 1:
            viewMensaje.isHidden = false
            imgMensaje.image = UIImage(named: "imgCarritoVacio")
            lblMensaje.text = "Actualmente no tienes productos y/o servicios en tus compras."
        case 2:
            if model.publicacionesFavoritas.count == 0
            {
                viewMensaje.isHidden = false
                imgMensaje.image = UIImage(named: "imgFavoritoVacio")
                lblMensaje.text = "Actualmente no tienes productos y/o servicios favoritos."
            } else
            {
                viewMensaje.isHidden = true
            }
        default:
            break
        }
        
        tableProductosServicios.reloadData()
    }
    
    @IBAction func indexChanged(_ sender: AnyObject)
    {
        Comando.getPublicaciones()
        
        NotificationCenter.default.addObserver(self, selector: #selector(CarritoComprasViewController.refrescarVista(_:)), name:NSNotification.Name(rawValue:"cargoPublicaciones"), object: nil)
    }
    
    // #pragma mark - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        switch segCtrlCarrito.selectedSegmentIndex
        {
        case 0:
            if model.publicacionesEnCarrito.count != 0
            {
                tableProductosServicios.separatorStyle = .singleLine
                return 1
            }
            
        case 1:
            tableProductosServicios.separatorStyle = .none
            return 0
            
        case 2:
            if model.publicacionesFavoritas.count != 0
            {
                tableProductosServicios.separatorStyle = .singleLine
                return 1
            }
            
        default:
            break
        }
        
        tableProductosServicios.separatorStyle = .none
        return 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        switch segCtrlCarrito.selectedSegmentIndex
        {
        case 0:
            if model.publicacionesEnCarrito.count != 0
            {
                return model.publicacionesEnCarrito.count
            }
        case 1:
            return 0
        case 2:
            return model.publicacionesFavoritas.count
        default:
            break
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "favoritoTableViewCell")  as! FavoritoTableViewCell
        
        switch segCtrlCarrito.selectedSegmentIndex
        {
        case 0:
            let cell = tableView.dequeueReusableCell(withIdentifier: "carritoTableViewCell")  as! CarritoTableViewCell
            
            let path = "productos/" + (model.publicacionesEnCarrito[indexPath.row].idPublicacion)! + "/" + (model.publicacionesEnCarrito[indexPath.row].publicacionCompra.fotos?[0].nombreFoto)!
            
            cell.imgPublicacion.loadImageUsingCacheWithUrlString(pathString: path)
            
            cell.lblNombrePublicacion.text = model.publicacionesEnCarrito[indexPath.row].publicacionCompra.nombre
            
            if (model.publicacionesEnCarrito[indexPath.row].servicio!)
            {
                if let amountString = model.publicacionesEnCarrito[indexPath.row].publicacionCompra.precio?.currencyInputFormatting()
                {
                    cell.lblCostoPublicacion.text = "\(amountString) (x1)"
                    cell.lblTotal.text = amountString
                }
            } else
            {
                if let amountStringDos = model.publicacionesEnCarrito[indexPath.row].publicacionCompra.precio?.currencyInputFormatting()
                {
                    cell.lblCostoPublicacion.text = "\(amountStringDos) (x\((model.publicacionesEnCarrito[indexPath.row].cantidadCompra)!))"
                }
                
                let costo:Int = Int((model.publicacionesEnCarrito[indexPath.row].publicacionCompra.precio!))!
                let Total:Int = (model.publicacionesEnCarrito[indexPath.row].cantidadCompra!) * costo
                let TotalString:String = String(Total)
                cell.lblTotal.text = TotalString
                
                if let amountStringDos = cell.lblTotal.text?.currencyInputFormatting()
                {
                    cell.lblTotal.text = amountStringDos
                }
            }
            
            cell.btnComprar.tag = indexPath.row
            cell.btnComprar.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
            
            return cell
        case 1:
            let cell = tableView.dequeueReusableCell(withIdentifier: "favoritoTableViewCell")  as! FavoritoTableViewCell
            return cell
        case 2:
            if let amountString = model.publicacionesFavoritas[indexPath.row].precio?.currencyInputFormatting()
            {
                cell.lblPrecio.text = amountString
            }
            
            cell.lblNombreProducto.text = model.publicacionesFavoritas[indexPath.row].nombre
            
            if (model.publicacionesFavoritas[indexPath.row].fotos?.count)! > 0
            {
                let path = "productos/" + (model.publicacionesFavoritas[indexPath.row].idPublicacion)! + "/" + (model.publicacionesFavoritas[indexPath.row].fotos?[0].nombreFoto)!
                
                cell.imgProducto.loadImageUsingCacheWithUrlString(pathString: path)
            }
            
        default:
            break
        }
        
        return cell
    }
    
    // Celda con botón
    func buttonAction(sender: UIButton!)
    {
        modelUsuario.publicacionCarrito = (model.publicacionesEnCarrito[sender.tag])
        
        self.performSegue(withIdentifier: "confirmacionUnoDesdeCarritoCompras", sender: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        switch segCtrlCarrito.selectedSegmentIndex
        {
        case 0:
            modelOferente.publicacion = (model.publicacionesEnCarrito[indexPath.row].publicacionCompra)
            
            if (modelUsuario.usuario[0].datosComplementarios?[0].carrito?[indexPath.row].servicio)!
            {
                self.performSegue(withIdentifier: "publicacionServicioDesdeVistaCarrito", sender: self)
            } else
            {
                self.performSegue(withIdentifier: "publicacionProductoDesdeVistaCarrito", sender: self)
            }
        case 1:
            print("Selected")
        case 2:
            modelOferente.publicacion = model.publicacionesFavoritas[indexPath.row]
            
            if modelOferente.publicacion.servicio!
            {
                self.performSegue(withIdentifier: "publicacionServicioDesdeVistaCarrito", sender: self)
            } else
            {
                self.performSegue(withIdentifier: "publicacionProductoDesdeVistaCarrito", sender: self)
            }
        default:
            break
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        switch segCtrlCarrito.selectedSegmentIndex
        {
        case 0:
            return 90
        case 1:
            return 100
        case 2:
            return 100
        default:
            break
        }
        
        return 100
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CarritoComprasViewController.refrescarVista(_:)), name:NSNotification.Name(rawValue:"cargoPublicaciones"), object: nil)
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
