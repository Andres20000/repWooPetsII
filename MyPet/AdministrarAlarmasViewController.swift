//
//  AdministrarAlarmasViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 4/07/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit
import FirebaseAuth
import UserNotifications

class AdministrarAlarmasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let modelUsuario = ModeloUsuario.sharedInstance
    
    let  user = FIRAuth.auth()?.currentUser
    
    @IBOutlet var tableAlertasMascota: UITableView!
    @IBOutlet var lblAviso: UILabel!
    
    var editarDatos:Bool = false
    
    @IBAction func backView(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        let nib = UINib(nibName: "AlertaTableViewCell", bundle: nil)
        tableAlertasMascota.register(nib, forCellReuseIdentifier: "alertaTableViewCell")
        
        printNotificaciones()
    }
    
    func printNotificaciones()
    {
        if #available(iOS 10.0, *)
        {
            let center = UNUserNotificationCenter.current()
            center.getPendingNotificationRequests(completionHandler: { requests in
                for request in requests {
                    
                    print("print 1: \(request.identifier)")
                    print("print 2: \(request.trigger)")
                }
            })
        } else {
            // Fallback on earlier versions
        }
    }
    
    func cargarAlertasMascota(_ notification: Notification)
    {
        modelUsuario.getAlarmasMascota(idMascota: modelUsuario.tuMascota.idMascota!)
        
        tableAlertasMascota.reloadData()
    }
    
    // #pragma mark - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if modelUsuario.alertasMascotaSeleccionada.count > 0
        {
            lblAviso.isHidden = false
            
            Comando.init().EmptyMessage("", tableView: tableAlertasMascota)
            
            tableAlertasMascota.separatorStyle = .singleLine
            
            return 1
        } else
        {
            Comando.init().EmptyMessage("No tienes alarmas programadas para tu mascota", tableView: tableAlertasMascota)
            
            tableAlertasMascota.separatorStyle = .none
            
            return 1
        }
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
        
        lbl.text = "  \(modelUsuario.tuMascota.nombre!)"
        
        vw .addSubview(lbl)
        vw.backgroundColor = UIColor.init(red: 0.980392156862745, green: 0.407843137254902, blue: 0.380392156862745, alpha: 1.0)
        
        return vw
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return modelUsuario.alertasMascotaSeleccionada.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alertaTableViewCell")  as! AlertaTableViewCell
        
        cell.lblFechaHora.text = "\(modelUsuario.alertasMascotaSeleccionada[indexPath.row].fechaInicio!)     \(modelUsuario.alertasMascotaSeleccionada[indexPath.row].hora!)"
        
        cell.lblTipo.text = modelUsuario.alertasMascotaSeleccionada[indexPath.row].tipoRecordatorio
        
        cell.lblTitulo.text = modelUsuario.alertasMascotaSeleccionada[indexPath.row].nombre
        
        cell.swEstadoAlarma.tag = indexPath.row
        cell.swEstadoAlarma .addTarget(self, action: #selector(AdministrarAlarmasViewController.stateChanged(_:)), for: .valueChanged)
        cell.swEstadoAlarma.setOn(modelUsuario.alertasMascotaSeleccionada[indexPath.row].activada!, animated: true)
        
        return cell;
    }
    
    func stateChanged(_ sender: UISwitch)
    {
        modelUsuario.alertaMascota = modelUsuario.alertasMascotaSeleccionada[sender.tag]
        
        if sender.isOn
        {
            editarDatos = true
            self.performSegue(withIdentifier: "alarmaDesdeAdministrarAlarmas", sender: self)
            
        } else
        {
            let alertController = UIAlertController (title: "Desactivar Alarma", message: "Estás seguro(a) de desactivar la alarma seleccionada?", preferredStyle: .alert)
            
            let continuarAction = UIAlertAction(title: "Sí, continuar", style: .default) { (_) -> Void in
                
                ComandoUsuario.desactivarAlertaMascota(uid: (self.user?.uid)!, alerta: self.modelUsuario.alertaMascota)
                self.cancelarNotificaciones(id: self.modelUsuario.alertaMascota.idAlerta!)
                
                ComandoUsuario.getUsuario(uid: (self.user?.uid)!)
                
                NotificationCenter.default.addObserver(self, selector: #selector(AdministrarAlarmasViewController.cargarAlertasMascota(_:)), name:NSNotification.Name(rawValue:"cargoUsuario"), object: nil)
            }
            
            let cancelAction = UIAlertAction(title: "Cancelar", style: .default) {
                UIAlertAction in
            }
            
            alertController.addAction(continuarAction)
            alertController.addAction(cancelAction)
            
            present(alertController, animated: true, completion: nil)
            
            tableAlertasMascota.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        modelUsuario.alertaMascota = modelUsuario.alertasMascotaSeleccionada[indexPath.row]
        
        editarDatos = true
        self.performSegue(withIdentifier: "alarmaDesdeAdministrarAlarmas", sender: self)
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool
    {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath)
    {
        modelUsuario.alertaMascota = modelUsuario.alertasMascotaSeleccionada[indexPath.row]
        
        if (editingStyle == .delete)
        {
            let alertController = UIAlertController (title: "Eliminar Alarma", message: "Estás seguro(a) de eliminar la alarma seleccionada?", preferredStyle: .alert)
            
            let continuarAction = UIAlertAction(title: "Sí, continuar", style: .default) { (_) -> Void in
                
                ComandoUsuario.eliminarAlertaMascota(uid: (self.user?.uid)!, alerta: self.modelUsuario.alertaMascota)
                self.cancelarNotificaciones(id: self.modelUsuario.alertaMascota.idAlerta!)
                
                ComandoUsuario.getUsuario(uid: (self.user?.uid)!)
                
                NotificationCenter.default.addObserver(self, selector: #selector(AdministrarAlarmasViewController.cargarAlertasMascota(_:)), name:NSNotification.Name(rawValue:"cargoUsuario"), object: nil)
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
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat
    {
        return 85
    }
    
    @IBAction func crearNuevaAlarma(_ sender: Any)
    {
        editarDatos = false
        self.performSegue(withIdentifier: "alarmaDesdeAdministrarAlarmas", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if user != nil
        {
            ComandoUsuario.getUsuario(uid: (user?.uid)!)
            
            NotificationCenter.default.addObserver(self, selector: #selector(AdministrarAlarmasViewController.cargarAlertasMascota(_:)), name:NSNotification.Name(rawValue:"cargoUsuario"), object: nil)
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
        
        if (segue.identifier == "alarmaDesdeAdministrarAlarmas")
        {
            let detailController = segue.destination as! AlarmaViewController
            detailController.datosEditables = editarDatos
        }
    }
    
    // Alarmas 
    
    func cancelarNotificaciones(id:String)
    {
        var lista:[String] = []
        
        for i in (0...64) {
            lista.append(id + String(i))
        }
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: lista)
        } else
        {
            // Fallback on earlier versions
            for i in (0...64) {
                removeNotification(taskTypeId: (id + String(i)))
            }
        }
    }
    
    func removeNotification(taskTypeId: String)
    {
        // loop through the pending notifications
        for notification in UIApplication.shared.scheduledLocalNotifications! as [UILocalNotification]
        {
            // Cancel the notification that corresponds to this task entry instance (matched by taskTypeId)
            if (notification.userInfo!["taskObjectId"] as? String == String(taskTypeId))
            {
                UIApplication.shared.cancelLocalNotification(notification)
                
                print("Notification deleted for taskTypeID: \(taskTypeId)")
                
                break
            }
        }
    }
}
