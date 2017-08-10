//
//  PublicacionOferenteTresViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 13/05/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class PublicacionOferenteTresViewController: UIViewController, UITextFieldDelegate, UITextViewDelegate
{
    // This constraint ties an element at zero points from the top layout guide
    @IBOutlet var horizontalSpaceConstraint: NSLayoutConstraint?
    @IBOutlet var bottomLayoutConstraint: NSLayoutConstraint?
    @IBOutlet var topLayoutConstraint: NSLayoutConstraint?
    
    let model = ModeloOferente.sharedInstance
    
    @IBOutlet var barItemTitulo: UIBarButtonItem!
    @IBOutlet var lblEtapaPublicacion_1: UILabel!
    @IBOutlet var lblEtapaPublicacion_2: UILabel!
    @IBOutlet var lblEtapaPublicacion_3: UILabel!
    @IBOutlet var lblEtapaPublicacion_4: UILabel!
    
    @IBOutlet var lblCampoTitulo: UILabel!
    @IBOutlet var txtTitulo: UITextField!
    @IBOutlet var lblCampoDescripcion: UILabel!
    @IBOutlet var textDescripcion: UITextView!
    @IBOutlet var lblCampoPrecio: UILabel!
    @IBOutlet var txtPrecio: UITextField!
    @IBOutlet var lblCampoCantidad: UILabel!
    @IBOutlet var txtCantidad: UITextField!
    @IBOutlet var lblCampoHorario: UILabel!
    @IBOutlet var btnHorario: UIButton!
    @IBOutlet var lblDiasSemana: UILabel!
    @IBOutlet var lblHorarioDiasSemana: UILabel!
    @IBOutlet var lblDiasFestivos: UILabel!
    @IBOutlet var lblHorarioDiasFestivos: UILabel!
    @IBOutlet var imgAdelante: UIImageView!
    
    @IBOutlet var btnContinuar: UIButton!
    
    var datosEditables:Bool = false
    
    @IBAction func backView(_ sender: Any)
    {
        if !datosEditables
        {
            model.horarioSemana.dias = ""
            model.horarioFestivo.dias = ""
            model.publicacion.horario?.removeAll()
            
            model.publicacion.descripcion = ""
            model.publicacion.nombre = ""
            model.publicacion.precio = ""
            model.publicacion.stock = ""
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
        
        textDescripcion.layer.cornerRadius = 5.0
        textDescripcion.layer.borderWidth = 0.5
        textDescripcion.layer.borderColor = UIColor.init(red: 0.843137254901961, green: 0.843137254901961, blue: 0.843137254901961, alpha: 1.0).cgColor
        
        self .toolBarTextField(txtTitulo)
        
        self .toolBarTextView(textDescripcion)
        
        self .toolBarTextField(txtPrecio)
        
        self .toolBarTextField(txtCantidad)
        
        if DeviceType.IS_IPHONE_5
        {
            // Definir espacio para cada dispositivo
            self.horizontalSpaceConstraint?.constant = 40.0
            self.bottomLayoutConstraint?.constant = 10.0
            
            lblCampoTitulo.font = UIFont (name: "Helvetica Neue", size: 14.0)
            lblCampoDescripcion.font = UIFont (name: "Helvetica Neue", size: 14.0)
            lblCampoPrecio.font = UIFont (name: "Helvetica Neue", size: 14.0)
            lblCampoCantidad.font = UIFont (name: "Helvetica Neue", size: 14.0)
            
            lblDiasSemana.font = UIFont (name: "HelveticaNeue-Light", size: 9.5)
            lblHorarioDiasSemana.font = UIFont (name: "HelveticaNeue-Light", size: 9.5)
            
            lblDiasFestivos.font = UIFont (name: "HelveticaNeue-Light", size: 9.5)
            lblHorarioDiasFestivos.font = UIFont (name: "HelveticaNeue-Light", size: 9.5)
        }
        
        if DeviceType.IS_IPHONE_6P
        {
            self.horizontalSpaceConstraint?.constant = 85.0
        }
        
        btnContinuar.layer.cornerRadius = 10.0
        btnContinuar.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        btnContinuar.isEnabled = false
        
        if model.publicacion.servicio!
        {
            lblCampoCantidad.isHidden = true
            txtCantidad.isHidden = true
            
            self.topLayoutConstraint?.constant = 55.0
            lblCampoHorario.isHidden = false
            lblCampoHorario.layer.masksToBounds = true
            lblCampoHorario.layer.cornerRadius = 5.0
            btnHorario.isHidden = false
            imgAdelante.isHidden = false
            
            lblDiasSemana.isHidden = true
            lblHorarioDiasSemana.isHidden = true
            lblDiasFestivos.isHidden = true
            lblHorarioDiasFestivos.isHidden = true
            
        } else
        {
            model.horarioSemana.dias = ""
            model.horarioFestivo.dias = ""
            
            lblCampoCantidad.isHidden = false
            txtCantidad.isHidden = false
            
            self.topLayoutConstraint?.constant = 90.0
            lblCampoHorario.isHidden = true
            btnHorario.isHidden = true
            lblDiasSemana.isHidden = true
            lblHorarioDiasSemana.isHidden = true
            lblDiasFestivos.isHidden = true
            lblHorarioDiasFestivos.isHidden = true
            imgAdelante.isHidden = true
        }
    }
    
    // #pragma mark - textField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        if textField.tag == 3
        {
            textField.text = ""
        }
        
        if DeviceType.IS_IPHONE_5
        {
            animateViewMoving(up: true, moveValue: 170)
        }
        
        if DeviceType.IS_IPHONE_6
        {
            animateViewMoving(up: true, moveValue: 100)
        }
        
        if DeviceType.IS_IPHONE_6P
        {
            animateViewMoving(up: true, moveValue: 50)
        }
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        if textField.tag == 1
        {
            model.publicacion.nombre = textField.text
        }
        
        if textField.tag == 3
        {
            if datosEditables
            {
                if textField.text == ""
                {
                    textField.text = model.publicacion.precio
                }else
                {
                    model.publicacion.precio = textField.text
                }
            }else
            {
                model.publicacion.precio = textField.text
            }
            
            
            if textField.text != ""
            {
                if let amountString = textField.text?.currencyInputFormatting()
                {
                    textField.text = amountString
                }
            }
        }
        
        if textField.tag == 4
        {
            model.publicacion.stock = textField.text
        }
        
        if DeviceType.IS_IPHONE_5
        {
            animateViewMoving(up: false, moveValue: 170)
        }
        
        if DeviceType.IS_IPHONE_6
        {
            animateViewMoving(up: false, moveValue: 100)
        }
        
        if DeviceType.IS_IPHONE_6P
        {
            animateViewMoving(up: false, moveValue: 50)
        }
        
        self .validarDatos()
    }
    
    // #pragma mark - textView
    
    func textViewDidBeginEditing(_ textView: UITextView)
    {
        if textView.text == "Descripción (mínimo 25 caracteres)"
        {
            textView.text = ""
            textView.textColor = UIColor.init(red: 0.301960784313725, green: 0.301960784313725, blue: 0.301960784313725, alpha: 1.0)
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView)
    {
        if (textView.text.characters.count) < 25
        {
            self.mostrarAlerta(titulo: "!Advertencia!", mensaje: "La descripción debe ser mínimo de 25 caracteres")
            
            textView.text = "Descripción (mínimo 25 caracteres)"
            textView.textColor = UIColor.lightGray
            
            model.publicacion.descripcion = ""
        }else
        {
            model.publicacion.descripcion = textView.text
        }
        
        self .validarDatos()
    }
    
    @IBAction func registrarHorarioServicio(_ sender: Any)
    {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        view.window!.layer.add(transition, forKey: kCATransition)
        
        self.performSegue(withIdentifier: "horarioDesdeNuevaPublicacion", sender: self)
    }
    
    @IBAction func continuarPublicacion(_ sender: Any)
    {
        if datosEditables
        {
            ComandoPublicacion.updateArticulo(idPublicacion: model.publicacion.idPublicacion!)
            
            dismiss(animated: true, completion: nil)
            
        }else
        {
            self.performSegue(withIdentifier: "publicacionOferenteCuatroDesdeAnterior", sender: self)
        }
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
    }
    
    override func viewDidAppear(_ animated: Bool)
    {
        super.viewDidAppear(animated)
        
        if datosEditables
        {
            barItemTitulo.title = "Editar publicación"
            btnContinuar.setTitle("Editar", for: .normal)
            btnContinuar.backgroundColor = UIColor.init(red: 0.050980392156863, green: 0.43921568627451, blue: 0.486274509803922, alpha: 1.0)
            btnContinuar.isEnabled = true
            
            textDescripcion.textColor = UIColor.init(red: 0.301960784313725, green: 0.301960784313725, blue: 0.301960784313725, alpha: 1.0)
            
        }else
        {
            barItemTitulo.title = "Nueva publicación"
            btnContinuar.setTitle("Continuar", for: .normal)
            btnContinuar.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
            btnContinuar.isEnabled = false
        }
        
        txtTitulo.text = model.publicacion.nombre
        textDescripcion.text = model.publicacion.descripcion
        
        if model.publicacion.descripcion == ""
        {
            textDescripcion.text = "Descripción (mínimo 25 caracteres)"
            textDescripcion.textColor = UIColor.lightGray
        }
        
        txtPrecio.text = model.publicacion.precio
        txtCantidad.text = model.publicacion.stock
        
        if txtPrecio.text != ""
        {
            if let amountString = txtPrecio.text?.currencyInputFormatting()
            {
                txtPrecio.text = amountString
            }
        }
        
        if model.publicacion.horario?.count != 0
        {
            model.publicacion.horario?.removeAll()
        }
        
        if model.horarioSemana.dias != ""
        {
            if model.publicacion.horario?.count == 0
            {
                model.publicacion.horario?.append(model.horarioSemana)
            } else
            {
                model.publicacion.horario?[0].dias = model.horarioSemana.dias
                model.publicacion.horario?[0].horaInicio = model.horarioSemana.horaInicio
                model.publicacion.horario?[0].horaCierre = model.horarioSemana.horaCierre
                model.publicacion.horario?[0].nombreArbol = "Semana"
            }
        }else
        {
            model.publicacion.horario?.removeAll()
        }
        
        if model.horarioFestivo.dias != ""
        {
            if model.publicacion.horario?.count == 1
            {
                model.publicacion.horario?.append(model.horarioFestivo)
            } else
            {
                model.publicacion.horario?[1].dias = model.horarioFestivo.dias
                model.publicacion.horario?[1].horaInicio = model.horarioFestivo.horaInicio
                model.publicacion.horario?[1].horaCierre = model.horarioFestivo.horaCierre
                model.publicacion.horario?[1].nombreArbol = "FinDeSemana"
            }
        }else
        {
            if model.publicacion.horario?.count == 2
            {
                model.publicacion.horario?.remove(at: 1)
            }
        }
        
        self .validarDatos()
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
        
        if (segue.identifier == "horarioDesdeNuevaPublicacion")
        {
            let detailController = segue.destination as! HorarioViewController
            detailController.horarioPara = "PublicacionServicio"
        }
    }

    func validarDatos()
    {
        if model.publicacion.horario?.count == 0
        {
            if model.publicacion.servicio!
            {
                self.topLayoutConstraint?.constant = 55.0
                lblDiasSemana.isHidden = true
                lblHorarioDiasSemana.isHidden = true
                lblDiasFestivos.isHidden = true
                lblHorarioDiasFestivos.isHidden = true
            }
        }else
        {
            if model.publicacion.horario?.count == 1
            {
                lblDiasSemana.text = model.publicacion.horario?[0].dias
                lblHorarioDiasSemana.text = (model.publicacion.horario?[0].horaInicio)! + " - " + (model.publicacion.horario?[0].horaCierre)!
                
                self.topLayoutConstraint?.constant = 70.0
                lblDiasSemana.isHidden = false
                lblHorarioDiasSemana.isHidden = false
            }else
            {
                lblDiasSemana.text = model.publicacion.horario?[0].dias
                lblHorarioDiasSemana.text = (model.publicacion.horario?[0].horaInicio)! + " - " + (model.publicacion.horario?[0].horaCierre)!
                
                lblDiasFestivos.text = model.publicacion.horario?[1].dias
                lblHorarioDiasFestivos.text = (model.publicacion.horario?[1].horaInicio)! + " - " + (model.publicacion.horario?[1].horaCierre)!
                
                self.topLayoutConstraint?.constant = 90.0
                lblDiasSemana.isHidden = false
                lblHorarioDiasSemana.isHidden = false
                
                lblDiasFestivos.isHidden = false
                lblHorarioDiasFestivos.isHidden = false
            }
        }
        
        if model.publicacion.nombre != "" && model.publicacion.descripcion != "" && model.publicacion.precio != ""
        {
            if model.publicacion.servicio!
            {
                if model.publicacion.horario?.count != 0
                {
                    btnContinuar.backgroundColor = UIColor.init(red: 0.050980392156863, green: 0.43921568627451, blue: 0.486274509803922, alpha: 1.0)
                    btnContinuar.isEnabled = true
                }else
                {
                    btnContinuar.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
                    btnContinuar.isEnabled = false
                }
            }else
            {
                if model.publicacion.stock != ""
                {
                    btnContinuar.backgroundColor = UIColor.init(red: 0.050980392156863, green: 0.43921568627451, blue: 0.486274509803922, alpha: 1.0)
                    btnContinuar.isEnabled = true
                }else
                {
                    btnContinuar.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
                    btnContinuar.isEnabled = false
                }
            }
        }else
        {
            btnContinuar.backgroundColor = UIColor.init(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
            btnContinuar.isEnabled = false
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
    
    // Move show/hide Keypoard
    func animateViewMoving (up:Bool, moveValue :CGFloat)
    {
        let movementDuration:TimeInterval = 0.3
        let movement:CGFloat = ( up ? -moveValue : moveValue)
        UIView.beginAnimations( "animateView", context: nil)
        UIView.setAnimationBeginsFromCurrentState(true)
        UIView.setAnimationDuration(movementDuration )
        self.view.frame = self.view.frame.offsetBy(dx: 0,  dy: movement)
        UIView.commitAnimations()
    }
    
    // Toolbar in textField
    func toolBarTextField(_ textField : UITextField)
    {
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 41/255, green: 184/255, blue: 200/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Ocultar", style: .plain, target: self, action: #selector(RegistroOferenteViewController.cancelClick))
        toolBar.setItems([spaceButton, cancelButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    // Toolbar in textField
    func toolBarTextView(_ textView : UITextView)
    {
        // ToolBar
        let toolBar = UIToolbar()
        toolBar.barStyle = .default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 41/255, green: 184/255, blue: 200/255, alpha: 1)
        toolBar.sizeToFit()
        
        // Adding Button ToolBar
        let spaceButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let cancelButton = UIBarButtonItem(title: "Ocultar", style: .plain, target: self, action: #selector(RegistroOferenteViewController.cancelClick))
        toolBar.setItems([spaceButton, cancelButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textView.inputAccessoryView = toolBar
    }
    
    // Button Cancelar Keyboard
    func cancelClick()
    {
        view.endEditing(true)
    }
}
