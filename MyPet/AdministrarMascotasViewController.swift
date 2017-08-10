//
//  AdministrarMascotasViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 27/06/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

import FirebaseAuth

class AdministrarMascotasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let model = ModeloUsuario.sharedInstance
    
    let  user = FIRAuth.auth()?.currentUser
    
    @IBOutlet var tableMascotas: UITableView!
    
    var editarDatos:Bool = false
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "MascotaTableViewCell", bundle: nil)
        tableMascotas.register(nib, forCellReuseIdentifier: "mascotaTableViewCell")
    }
    
    @IBAction func goHome(_ sender: Any)
    {
        self.performSegue(withIdentifier: "precargarPublicacionesDesdeAdministrarMascotas", sender: self)
    }
    
    func cargarMascotas(_ notification: Notification)
    {
        model.mascotas = (model.usuario[0].datosComplementarios?[0].mascotas!)!
        
        tableMascotas.reloadData()
    }
    
    // #pragma mark - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String?
    {
        return "Section \(section)"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat
    {
        return 35
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let vw = UIView()
        let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 320, height: 35))
        lbl.font = UIFont (name: "HelveticaNeue-Light", size: 17.0)
        lbl.textColor = UIColor.white
        
        lbl.text = "  Tus mascotas"
        
        vw .addSubview(lbl)
        vw.backgroundColor = UIColor.init(red: 0.980392156862745, green: 0.407843137254902, blue: 0.380392156862745, alpha: 1.0)
        
        return vw
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return model.mascotas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mascotaTableViewCell")  as! MascotaTableViewCell
        
        if model.mascotas[indexPath.row].foto == ""
        {
            cell.imgFotoMascota.image = UIImage(named: "btnFotoMascota")
        } else
        {
            let path = "mascotas/" + (user?.uid)! + "/" + (model.mascotas[indexPath.row].idMascota)! + "/" + (model.mascotas[indexPath.row].foto)!
            
            cell.imgFotoMascota.loadImageUsingCacheWithUrlString(pathString: path)
            
            cell.imgFotoMascota.translatesAutoresizingMaskIntoConstraints = false
            cell.imgFotoMascota.layer.masksToBounds = true
            cell.imgFotoMascota.contentMode = .scaleAspectFill
            cell.imgFotoMascota.leftAnchor.constraint(equalTo: cell.imgFotoMascota.leftAnchor, constant: 8).isActive = true
            cell.imgFotoMascota.centerYAnchor.constraint(equalTo: cell.imgFotoMascota.centerYAnchor).isActive = true
            cell.imgFotoMascota.widthAnchor.constraint(equalToConstant: cell.imgFotoMascota.frame.width).isActive = true
            cell.imgFotoMascota.heightAnchor.constraint(equalToConstant: cell.imgFotoMascota.frame.height).isActive = true
            cell.imgFotoMascota.layer.cornerRadius = cell.imgFotoMascota.frame.height / 2
        }
        
        cell.btnActivarPerfil.tag = indexPath.row
        cell.btnActivarPerfil.addTarget(self, action: #selector(seleccionarMascota), for: .touchUpInside)
        
        if model.mascotas[indexPath.row].activa!
        {
            cell.btnActivarPerfil.setImage(UIImage(named: "imgActivo"), for: UIControlState.normal)
        } else
        {
            cell.btnActivarPerfil.setImage(UIImage(named: "imgInactivo"), for: UIControlState.normal)
        }
        
        cell.lblNombreMascota.text = model.mascotas[indexPath.row].nombre
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let yearDate = Comando.calcularEdadEnAños(birthday: dateFormatter.date(from: model.mascotas[indexPath.row].fechaNacimiento!)! as NSDate)
        var textYear:String?
        
        if yearDate == 1
        {
            textYear = "año"
        } else
        {
            textYear = "años"
        }
        
        let monthDate = Comando.calcularEdadEnMeses(birthday: dateFormatter.date(from: model.mascotas[indexPath.row].fechaNacimiento!)! as NSDate) - (yearDate * 12)
        var textMonth:String?
        
        if monthDate == 1
        {
            textMonth = "mes"
        } else
        {
            textMonth = "meses"
        }
        
        cell.lblEdadMascota.text = "\(yearDate) \(textYear!), \(monthDate) \(textMonth!)"
        
        cell.btnAlarmas.tag = indexPath.row
        cell.btnAlarmas.addTarget(self, action: #selector(verAlarmasMascota), for: .touchUpInside)
        
        if model.mascotas[indexPath.row].alertas?.count == 0
        {
            cell.btnAlarmas.setImage(UIImage(named: "btnAlarmaOff"), for: UIControlState.normal)
        } else
        {
            cell.btnAlarmas.setImage(UIImage(named: "btnAlarmaOn"), for: UIControlState.normal)
        }
        
        return cell;
    }
    
    func seleccionarMascota(sender: UIButton!)
    {
        if model.mascotas[sender.tag].activa!
        {
            self.mostrarAlerta(titulo: "Advertencia", mensaje: "Este perfil ya se encuentra como principal")
        } else
        {
            ComandoUsuario.activarMascota(uid: (user?.uid)!, idMascota: model.mascotas[sender.tag].idMascota, datos: (model.usuario[0].datosComplementarios?[0])!)
            
            ComandoUsuario.getUsuario(uid: (user?.uid)!)
            
            NotificationCenter.default.addObserver(self, selector: #selector(AdministrarMascotasViewController.cargarMascotas(_:)), name:NSNotification.Name(rawValue:"cargoUsuario"), object: nil)
        }
    }
    
    func verAlarmasMascota(sender: UIButton!)
    {
        model.tuMascota = model.mascotas[sender.tag]
        
        self.performSegue(withIdentifier: "administrarAlarmasDesdeAdministrarMascotas", sender: self)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        editarDatos = true
        
        model.tuMascota = model.mascotas[indexPath.row]
        
        self.performSegue(withIdentifier: "tuMascotaDesdeAdministrarMascotas", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "mascotaTableViewCell")  as! MascotaTableViewCell
        
        if (editingStyle == .delete)
        {
            let alertController = UIAlertController (title: "Eliminar Mascota", message: "Está seguro(a) de eliminar el perfil de la mascota seleccionada?", preferredStyle: .alert)
            
            let continuarAction = UIAlertAction(title: "Sí, continuar", style: .default) { (_) -> Void in
                
                if self.model.mascotas[indexPath.row].activa!
                {
                    self.mostrarAlerta(titulo: "Advertencia", mensaje: "Este perfil se encuentra como principal y no es es posible eliminar")
                } else
                {
                    if self.model.mascotas[indexPath.row].foto != ""
                    {
                        ComandoUsuario.deleteFotoMascota(uid: (self.user?.uid)!, idMascota: self.model.mascotas[indexPath.row].idMascota!, nombreFoto: self.model.mascotas[indexPath.row].foto!)
                        
                        let path = "mascotas/" + (self.user?.uid)! + "/" + self.model.mascotas[indexPath.row].idMascota! + "/" + self.model.mascotas[indexPath.row].foto!
                        cell.imgFotoMascota.deleteImageCache(pathString: path)
                    }
                    
                    ComandoUsuario.eliminarPerfilMascota(uid: (self.user?.uid)!, mascota: self.model.mascotas[indexPath.row])
                    
                    ComandoUsuario.getUsuario(uid: (self.user?.uid)!)
                    
                    NotificationCenter.default.addObserver(self, selector: #selector(AdministrarMascotasViewController.cargarMascotas(_:)), name:NSNotification.Name(rawValue:"cargoUsuario"), object: nil)
                    
                }
            }
            
            let cancelAction = UIAlertAction(title: "Cancelar", style: .default) {
                UIAlertAction in
            }
            
            alertController.addAction(continuarAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
            // handle delete (by removing the data from your array and updating the tableview)
        }
    }
    
    /*func tableView(_ tableView: UITableView, editActionsForRowAt: IndexPath) -> [UITableViewRowAction]?
    {
        let more = UITableViewRowAction(style: .destructive, title: "More") { action, index in
            print("more button tapped")
        }
        more.backgroundColor = .lightGray
        
        let favorite = UITableViewRowAction(style: .normal, title: "Favorite") { action, index in
            print("favorite button tapped")
        }
        favorite.backgroundColor = .orange
        
        let share = UITableViewRowAction(style: .normal, title: "Share") { action, index in
            print("share button tapped")
        }
        share.backgroundColor = .blue
        
        return [share, favorite, more]
    }*/
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 80
    }
    
    @IBAction func crearNuevaMascota(_ sender: Any)
    {
        editarDatos = false
        self.performSegue(withIdentifier: "tuMascotaDesdeAdministrarMascotas", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if user != nil
        {
            ComandoUsuario.getUsuario(uid: (user?.uid)!)
            
            NotificationCenter.default.addObserver(self, selector: #selector(AdministrarMascotasViewController.cargarMascotas(_:)), name:NSNotification.Name(rawValue:"cargoUsuario"), object: nil)
        }
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
        
        if (segue.identifier == "tuMascotaDesdeAdministrarMascotas")
        {
            let detailController = segue.destination as! TuMascotaViewController
            detailController.datosEditables = editarDatos
        }
        
        if (segue.identifier == "precargarPublicacionesDesdeAdministrarMascotas")
        {
            let detailController = segue.destination as! PreCargaDatosViewController
            detailController.omitir = false
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
