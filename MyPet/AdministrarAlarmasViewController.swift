//
//  AdministrarAlarmasViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 4/07/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

import FirebaseAuth

class AdministrarAlarmasViewController: UIViewController, UITableViewDelegate, UITableViewDataSource
{
    let model = ModeloUsuario.sharedInstance
    
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
    }

    func cargarAlertasMascota(_ notification: Notification)
    {
        model.alertasMascotaSeleccionada = model.tuMascota.alertas!
        
        tableAlertasMascota.reloadData()
    }
    
    // #pragma mark - Table View
    
    func numberOfSections(in tableView: UITableView) -> Int
    {
        if model.alertasMascotaSeleccionada.count > 0
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
        
        lbl.text = "  \(model.tuMascota.nombre!)"
        
        vw .addSubview(lbl)
        vw.backgroundColor = UIColor.init(red: 0.980392156862745, green: 0.407843137254902, blue: 0.380392156862745, alpha: 1.0)
        
        return vw
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int
    {
        return model.alertasMascotaSeleccionada.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCell(withIdentifier: "alertaTableViewCell")  as! AlertaTableViewCell
        
        return cell;
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath)
    {
        print("Seleccionada")
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

}
