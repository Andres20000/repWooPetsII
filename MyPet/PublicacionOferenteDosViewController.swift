//
//  PublicacionOferenteDosViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 13/05/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class PublicacionOferenteDosViewController: UIViewController
{
    // This constraint ties an element at zero points from the top layout guide
    @IBOutlet var horizontalSpaceConstraint: NSLayoutConstraint?
    
    let model = ModeloOferente.sharedInstance
    
    var tipoMascotas = ModeloOferente.sharedInstance.tipoMascotas
    
    @IBOutlet var barItemTitulo: UIBarButtonItem!
    @IBOutlet var lblEtapaPublicacion_1: UILabel!
    @IBOutlet var lblEtapaPublicacion_2: UILabel!
    @IBOutlet var lblEtapaPublicacion_3: UILabel!
    @IBOutlet var lblEtapaPublicacion_4: UILabel!
    
    @IBOutlet var lblTexto: UILabel!
    
    @IBOutlet var imgSelectPerro: UIImageView!
    @IBOutlet var imgSelectGato: UIImageView!
    @IBOutlet var imgSelectAve: UIImageView!
    @IBOutlet var imgSelectPez: UIImageView!
    @IBOutlet var imgSelectRoedor: UIImageView!
    @IBOutlet var imgSelectExotico: UIImageView!
    
    @IBOutlet var btnContinuar: UIButton!
    
    var datosEditables:Bool = false
    
    @IBAction func backView(_ sender: Any)
    {
        if !datosEditables
        {
            model.publicacion.target = ""
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        lblEtapaPublicacion_1.layer.masksToBounds = true
        lblEtapaPublicacion_1.layer.cornerRadius = 22.0
        
        lblEtapaPublicacion_2.layer.masksToBounds = true
        lblEtapaPublicacion_2.layer.cornerRadius = 22.0
        
        lblEtapaPublicacion_3.layer.masksToBounds = true
        lblEtapaPublicacion_3.layer.cornerRadius = 22.0
        
        lblEtapaPublicacion_4.layer.masksToBounds = true
        lblEtapaPublicacion_4.layer.cornerRadius = 22.0
        
        btnContinuar.layer.cornerRadius = 10.0
        
        if datosEditables
        {
            barItemTitulo.title = "Editar publicación"
            btnContinuar.setTitle("Editar", for: .normal)
            btnContinuar.backgroundColor = UIColor.init(red: 0.050980392156863, green: 0.43921568627451, blue: 0.486274509803922, alpha: 1.0)
            btnContinuar.isEnabled = true
            
        }else
        {
            barItemTitulo.title = "Nueva publicación"
            btnContinuar.setTitle("Continuar", for: .normal)
            btnContinuar.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
            btnContinuar.isEnabled = false
        }
        
        if model.publicacion.servicio!
        {
            lblTexto.text = "Selecciona el tipo de animal al cual está dirigido el servicio"
        } else
        {
            lblTexto.text = "Selecciona el tipo de animal al cual está dirigido el producto"
        }
        
        // Definir espacio para cada dispositivo
        if DeviceType.IS_IPHONE_5
        {
            self.horizontalSpaceConstraint?.constant = 40.0
            lblTexto.font = UIFont (name: "Helvetica Neue", size: 15.0)
            
        }
        
        if DeviceType.IS_IPHONE_6P
        {
            self.horizontalSpaceConstraint?.constant = 85.0
            lblTexto.font = UIFont (name: "Helvetica Neue", size: 20.0)
        }
        
        imgSelectPerro.apagar()
        imgSelectGato.apagar()
        imgSelectAve.apagar()
        imgSelectPez.apagar()
        imgSelectRoedor.apagar()
        imgSelectExotico.apagar()
        
        if model.publicacion.target == ""
        {
            return
        }else
        {
            if tipoMascotas == nil {
                
                tipoMascotas = TipoMascotas()
            }
            
            tipoMascotas?.adicionarMascota(mascotas: model.publicacion.target!)
            
        }
        
        if (tipoMascotas?.esMascotaIncluido(miMascota: .perro))! {
            imgSelectPerro.prender()
        }
        
        if (tipoMascotas?.esMascotaIncluido(miMascota: .gato))! {
            imgSelectGato.prender()
        }
        
        if (tipoMascotas?.esMascotaIncluido(miMascota: .ave))! {
            imgSelectAve.prender()
        }
        
        if (tipoMascotas?.esMascotaIncluido(miMascota: .pez))! {
            imgSelectPez.prender()
        }
        
        if (tipoMascotas?.esMascotaIncluido(miMascota: .roedor))! {
            imgSelectRoedor.prender()
        }
        
        if (tipoMascotas?.esMascotaIncluido(miMascota: .exotico))! {
            imgSelectExotico.prender()
        }
    }
    
    @IBAction func selectTipo(_ sender: Any)
    {
        let btnTipo:UIButton = sender as! UIButton
        
        switch btnTipo.tag {
        case 1:
            imgSelectPerro.cambiar()
        case 2:
            imgSelectGato.cambiar()
        case 3:
            imgSelectAve.cambiar()
        case 4:
            imgSelectPez.cambiar()
        case 5:
            imgSelectRoedor.cambiar()
        case 6:
            imgSelectExotico.cambiar()
        default:
            print("Nothing")
        }
        
        if !imgSelectPerro.isOn() && !imgSelectGato.isOn() && !imgSelectAve.isOn() && !imgSelectPez.isOn() && !imgSelectRoedor.isOn() && !imgSelectExotico.isOn()
        {
            btnContinuar.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
            btnContinuar.isEnabled = false
        } else
        {
            btnContinuar.backgroundColor = UIColor.init(red: 0.050980392156863, green: 0.43921568627451, blue: 0.486274509803922, alpha: 1.0)
            btnContinuar.isEnabled = true
        }
    }
    
    func setMascotas()
    {
        var newMascotas:[Mascotas] = []
        
        if imgSelectPerro.isOn() {
            newMascotas.append(.perro)
        }
        
        if imgSelectGato.isOn() {
            newMascotas.append(.gato)
        }
        if imgSelectAve.isOn() {
            newMascotas.append(.ave)
        }
        if imgSelectPez.isOn() {
            newMascotas.append(.pez)
        }
        
        if imgSelectRoedor.isOn() {
            newMascotas.append(.roedor)
        }
        
        if imgSelectExotico.isOn() {
            newMascotas.append(.exotico)
        }
        
        if tipoMascotas == nil {
            tipoMascotas = TipoMascotas()
        }
        
        tipoMascotas?.mascotas = newMascotas
    }
    
    @IBAction func continuarPublicacion(_ sender: Any)
    {
        setMascotas()
        
        if datosEditables
        {
            model.publicacion.target = tipoMascotas?.getMascotasPegadosLargos()
            ComandoPublicacion.updateTipo(idPublicacion: model.publicacion.idPublicacion!, tipo: model.publicacion.target!)
            
            dismiss(animated: true, completion: nil)
            
        }else
        {
            model.publicacion.target = tipoMascotas?.getMascotasPegadosLargos()
            
            self.performSegue(withIdentifier: "publicacionOferenteTresDesdeAnterior", sender: self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
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
