//
//  RegistroUsuarioTresViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 9/06/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

import Firebase

class RegistroUsuarioTresViewController: UIViewController, UITextFieldDelegate
{
    var model  = ModeloUsuario.sharedInstance
    
    // This constraint ties an element at zero points from the top layout guide
    @IBOutlet var spaceBottomLayoutConstraint: NSLayoutConstraint?
    
    @IBOutlet var imgMailFB: UIImageView!
    @IBOutlet var swiTarjeta: UISwitch!
    @IBOutlet var txtNombreTarjeta: UITextField!
    @IBOutlet var txtNumeroTarjeta: UITextField!
    @IBOutlet var txtAnoVencimiento: UITextField!
    @IBOutlet var txtMesVencimiento: UITextField!
    @IBOutlet var txtDireccion: UITextField!
    @IBOutlet var txtPais: UITextField!
    @IBOutlet var txtCiudad: UITextField!
    @IBOutlet var txtCVC: UITextField!
    @IBOutlet var swiEfectivo: UISwitch!
    
    @IBOutlet var btnFinalizar: UIButton!
    
    @IBAction func closeView(_ sender: Any)
    {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if Comando.validarTipoIngreso()
        {
            imgMailFB.image = UIImage(named: "imgFbOk")
        }else
        {
            imgMailFB.image = UIImage(named: "imgMailOk")
        }
    }
    
    @IBAction func cambiarView(_ sender: Any)
    {
        let connectedRef = FIRDatabase.database().reference(withPath: ".info/connected")
        
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
                self.finalizarRegistro()
            } else {
                self.mostrarAlerta(titulo: "Sin conexión", mensaje: "No detectamos conexión a internet, por favor valida tu señal para poder terminar tu registro.")
            }
        })
    }
    
    func finalizarRegistro()
    {
        model.registroComplementario.pagoEfectvo = true
        
        let  user = FIRAuth.auth()?.currentUser
        
        ComandoUsuario.completarRegistro(uid: (user?.uid)!, correo: (user?.email)!, datos: model.registroComplementario)
        
        self.performSegue(withIdentifier: "registroExitoso", sender: self)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        if DeviceType.IS_IPHONE_5
        {
            self.spaceBottomLayoutConstraint?.constant = 25.0
        }
        
        let spacerViewTxtNombreTarjeta = UIView(frame:CGRect(x:0, y:0, width:5, height:5))
        
        txtNombreTarjeta.leftViewMode = UITextFieldViewMode.always
        txtNombreTarjeta.leftView = spacerViewTxtNombreTarjeta
        txtNombreTarjeta.text = ""
        txtNombreTarjeta.attributedPlaceholder = NSAttributedString(string:"Nombre registrado en la tarjeta", attributes:[NSForegroundColorAttributeName: UIColor.init(red: 0.188235294117647, green: 0.188235294117647, blue: 0.188235294117647, alpha: 1.0)])
        
        let spacerViewTxtNumeroTarjeta = UIView(frame:CGRect(x:0, y:0, width:5, height:5))
        
        txtNumeroTarjeta.leftViewMode = UITextFieldViewMode.always
        txtNumeroTarjeta.leftView = spacerViewTxtNumeroTarjeta
        txtNumeroTarjeta.text = ""
        txtNumeroTarjeta.attributedPlaceholder = NSAttributedString(string:"Número de tarjeta", attributes:[NSForegroundColorAttributeName: UIColor.init(red: 0.188235294117647, green: 0.188235294117647, blue: 0.188235294117647, alpha: 1.0)])
        
        let spacerViewTxtAnoVencimiento = UIView(frame:CGRect(x:0, y:0, width:5, height:5))
        
        txtAnoVencimiento.leftViewMode = UITextFieldViewMode.always
        txtAnoVencimiento.leftView = spacerViewTxtAnoVencimiento
        txtAnoVencimiento.text = ""
        txtAnoVencimiento.attributedPlaceholder = NSAttributedString(string:"Año vencimiento", attributes:[NSForegroundColorAttributeName: UIColor.init(red: 0.188235294117647, green: 0.188235294117647, blue: 0.188235294117647, alpha: 1.0)])
        
        let spacerViewTxtMesVencimiento = UIView(frame:CGRect(x:0, y:0, width:5, height:5))
        
        txtMesVencimiento.leftViewMode = UITextFieldViewMode.always
        txtMesVencimiento.leftView = spacerViewTxtMesVencimiento
        txtMesVencimiento.text = ""
        txtMesVencimiento.attributedPlaceholder = NSAttributedString(string:"Mes vencimiento", attributes:[NSForegroundColorAttributeName: UIColor.init(red: 0.188235294117647, green: 0.188235294117647, blue: 0.188235294117647, alpha: 1.0)])
        
        let spacerViewTxtDireccion = UIView(frame:CGRect(x:0, y:0, width:5, height:5))
        
        txtDireccion.leftViewMode = UITextFieldViewMode.always
        txtDireccion.leftView = spacerViewTxtDireccion
        txtDireccion.text = ""
        txtDireccion.attributedPlaceholder = NSAttributedString(string:"Dirección registrada en la tarjeta", attributes:[NSForegroundColorAttributeName: UIColor.init(red: 0.188235294117647, green: 0.188235294117647, blue: 0.188235294117647, alpha: 1.0)])
        
        let spacerViewTxtPais = UIView(frame:CGRect(x:0, y:0, width:5, height:5))
        
        txtPais.leftViewMode = UITextFieldViewMode.always
        txtPais.leftView = spacerViewTxtPais
        txtPais.text = ""
        txtPais.attributedPlaceholder = NSAttributedString(string:"País", attributes:[NSForegroundColorAttributeName: UIColor.init(red: 0.188235294117647, green: 0.188235294117647, blue: 0.188235294117647, alpha: 1.0)])
        
        let spacerViewTxtCiudad = UIView(frame:CGRect(x:0, y:0, width:5, height:5))
        
        txtCiudad.leftViewMode = UITextFieldViewMode.always
        txtCiudad.leftView = spacerViewTxtCiudad
        txtCiudad.text = ""
        txtCiudad.attributedPlaceholder = NSAttributedString(string:"Ciudad", attributes:[NSForegroundColorAttributeName: UIColor.init(red: 0.188235294117647, green: 0.188235294117647, blue: 0.188235294117647, alpha: 1.0)])
        
        let spacerViewTxtCVC = UIView(frame:CGRect(x:0, y:0, width:5, height:5))
        
        txtCVC.leftViewMode = UITextFieldViewMode.always
        txtCVC.leftView = spacerViewTxtCVC
        txtCVC.text = ""
        txtCVC.attributedPlaceholder = NSAttributedString(string:"CVC (Código de seguridad)", attributes:[NSForegroundColorAttributeName: UIColor.init(red: 0.188235294117647, green: 0.188235294117647, blue: 0.188235294117647, alpha: 1.0)])
        
        btnFinalizar.layer.cornerRadius = 10.0
        
        swiTarjeta .addTarget(self, action: #selector(RegistroUsuarioTresViewController.stateChanged(_:)), for: .valueChanged)
        swiEfectivo .addTarget(self, action: #selector(RegistroUsuarioTresViewController.stateChanged(_:)), for: .valueChanged)
    }
    
    func stateChanged(_ sender: UISwitch)
    {
        if sender.tag == 1
        {
            if sender.isOn
            {
                print("true")
            } else
            {
                print("false")
            }
        } else
        {
            if sender.isOn
            {
                print("true")
            } else
            {
                print("false")
            }
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
