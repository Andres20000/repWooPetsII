//
//  AlarmaViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 10/07/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class AlarmaViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate
{
    let model = Modelo.sharedInstance
    let modelUsuario = ModeloUsuario.sharedInstance
    
    let pickerTipoRecordatorio = UIPickerView()
    let pickerFrecuencia = UIPickerView()
    
    var datePickerHora = UIDatePicker()
    var datePickerFechaInicio = UIDatePicker()
    var datePickerFechaFin = UIDatePicker()
    
    // This constraint ties an element at zero points from the top layout guide
    @IBOutlet var spaceTopLayoutConstraint: NSLayoutConstraint?
    @IBOutlet var spaceBottomLayoutConstraint: NSLayoutConstraint?
    
    @IBOutlet var txtTipoRecordatorio: UITextField!
    @IBOutlet var txtNombreRecordatorio: UITextField!
    @IBOutlet var txtHora: UITextField!
    @IBOutlet var txtFrecuencia: UITextField!
    @IBOutlet var txtFechaInicio: UITextField!
    @IBOutlet var txtFechaFin: UITextField!
    
    @IBOutlet var btnAceptar: UIButton!
    @IBOutlet var btnCancelar: UIButton!
    
    var datosEditables:Bool = false
    
    @IBAction func backView(_ sender: Any)
    {
        self .abandonar()
    }
    
    override func viewDidLoad()
    {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        if DeviceType.IS_IPHONE_5
        {
            spaceTopLayoutConstraint?.constant = 20.0
            spaceBottomLayoutConstraint?.constant = 20.0
        }
        
        let spacerViewtxtTipoRecordatorio = UIView(frame:CGRect(x:0, y:0, width:5, height:5))
        
        txtTipoRecordatorio.leftViewMode = UITextFieldViewMode.always
        txtTipoRecordatorio.leftView = spacerViewtxtTipoRecordatorio
        txtTipoRecordatorio.text = ""
        txtTipoRecordatorio.attributedPlaceholder = NSAttributedString(string:"Tipo de recordatorio", attributes:[NSForegroundColorAttributeName: UIColor.init(red: 0.188235294117647, green: 0.188235294117647, blue: 0.188235294117647, alpha: 1.0)])
        
        self .toolBarTextField(txtTipoRecordatorio)
        
        let spacerViewtxtNombreRecordatorio = UIView(frame:CGRect(x:0, y:0, width:5, height:5))
        
        txtNombreRecordatorio.leftViewMode = UITextFieldViewMode.always
        txtNombreRecordatorio.leftView = spacerViewtxtNombreRecordatorio
        txtNombreRecordatorio.text = ""
        txtNombreRecordatorio.attributedPlaceholder = NSAttributedString(string:"Nombre del recordatorio", attributes:[NSForegroundColorAttributeName: UIColor.init(red: 0.188235294117647, green: 0.188235294117647, blue: 0.188235294117647, alpha: 1.0)])
        
        let spacerViewtxtHora = UIView(frame:CGRect(x:0, y:0, width:5, height:5))
        
        txtHora.leftViewMode = UITextFieldViewMode.always
        txtHora.leftView = spacerViewtxtHora
        txtHora.text = ""
        txtHora.attributedPlaceholder = NSAttributedString(string:"Hora", attributes:[NSForegroundColorAttributeName: UIColor.init(red: 0.188235294117647, green: 0.188235294117647, blue: 0.188235294117647, alpha: 1.0)])
        
        self .pickUpDateHora(txtHora)
        self .toolBarTextField(txtHora)
        
        let spacerViewtxtFrecuencia = UIView(frame:CGRect(x:0, y:0, width:5, height:5))
        
        txtFrecuencia.leftViewMode = UITextFieldViewMode.always
        txtFrecuencia.leftView = spacerViewtxtFrecuencia
        txtFrecuencia.text = ""
        txtFrecuencia.attributedPlaceholder = NSAttributedString(string:"Frecuencia", attributes:[NSForegroundColorAttributeName: UIColor.init(red: 0.188235294117647, green: 0.188235294117647, blue: 0.188235294117647, alpha: 1.0)])
        
        self .toolBarTextField(txtFrecuencia)
        
        let spacerViewtxtFechaInicio = UIView(frame:CGRect(x:0, y:0, width:5, height:5))
        
        txtFechaInicio.leftViewMode = UITextFieldViewMode.always
        txtFechaInicio.leftView = spacerViewtxtFechaInicio
        txtFechaInicio.text = ""
        txtFechaInicio.attributedPlaceholder = NSAttributedString(string:"Fecha inicio", attributes:[NSForegroundColorAttributeName: UIColor.init(red: 0.188235294117647, green: 0.188235294117647, blue: 0.188235294117647, alpha: 1.0)])
        
        self .pickUpDateFechaInicio(txtFechaInicio)
        self .toolBarTextField(txtFechaInicio)
        
        let spacerViewtxtFechaFin = UIView(frame:CGRect(x:0, y:0, width:5, height:5))
        
        txtFechaFin.leftViewMode = UITextFieldViewMode.always
        txtFechaFin.leftView = spacerViewtxtFechaFin
        txtFechaFin.text = ""
        txtFechaFin.attributedPlaceholder = NSAttributedString(string:"Fecha fin", attributes:[NSForegroundColorAttributeName: UIColor.init(red: 0.188235294117647, green: 0.188235294117647, blue: 0.188235294117647, alpha: 1.0)])
        
        self .pickUpDateFechaFin(txtFechaFin)
        self .toolBarTextField(txtFechaFin)
        
        btnAceptar.layer.cornerRadius = 10.0
        
        btnCancelar.layer.cornerRadius = 10.0
    }
    
    func cargarDatos(_ notification: Notification)
    {
        pickerTipoRecordatorio.delegate = self
        pickerTipoRecordatorio.dataSource = self as? UIPickerViewDataSource
        pickerTipoRecordatorio.tag = 1
        
        txtTipoRecordatorio.inputView = pickerTipoRecordatorio
        
        pickerFrecuencia.delegate = self
        pickerFrecuencia.dataSource = self as? UIPickerViewDataSource
        pickerFrecuencia.tag = 2
        
        txtFrecuencia.inputView = pickerFrecuencia
    }
    
    // #pragma mark - pickerView
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int
    {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int
    {
        if pickerView.tag == 1
        {
            return model.tiposRecordatorio.count
        }
        
        if pickerView.tag == 2
        {
            return model.frecuenciasRecordatorio.count
        }
        
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String?
    {
        var dato:String?
        
        if pickerView.tag == 1
        {
            dato = model.tiposRecordatorio[row].nombreTipo
        }
        
        if pickerView.tag == 2
        {
            dato = model.frecuenciasRecordatorio[row].nombreFrecuencia
        }
        
        return dato
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        if pickerView.tag == 1
        {
            txtTipoRecordatorio.text = model.tiposRecordatorio[row].nombreTipo
        }
        
        if pickerView.tag == 2
        {
            txtFrecuencia.text = model.frecuenciasRecordatorio[row].nombreFrecuencia
        }
    }
    
    // #pragma mark - DatePicker
    
    func pickUpDateHora(_ textField : UITextField)
    {
        // DatePicker
        self.datePickerHora = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePickerHora.backgroundColor = UIColor.white
        self.datePickerHora.datePickerMode = UIDatePickerMode.time
        self.datePickerHora.addTarget(self, action: #selector(AlarmaViewController.actualizarHora), for: .valueChanged)
        textField.inputView = self.datePickerHora
    }
    
    func actualizarHora()
    {
        txtHora.text = datePickerHora.date.horaString()
    }
    
    func pickUpDateFechaInicio(_ textField : UITextField)
    {
        // DatePicker
        self.datePickerFechaInicio = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePickerFechaInicio.backgroundColor = UIColor.white
        self.datePickerFechaInicio.datePickerMode = UIDatePickerMode.date
        self.datePickerFechaInicio.minimumDate = NSDate() as Date
        self.datePickerFechaInicio.addTarget(self, action: #selector(AlarmaViewController.actualizarFechaInicio), for: .valueChanged)
        textField.inputView = self.datePickerFechaInicio
    }
    
    func actualizarFechaInicio()
    {
        txtFechaInicio.text = datePickerFechaInicio.date.fechaString()
    }
    
    func pickUpDateFechaFin(_ textField : UITextField)
    {
        // DatePicker
        self.datePickerFechaFin = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePickerFechaFin.backgroundColor = UIColor.white
        self.datePickerFechaFin.datePickerMode = UIDatePickerMode.date
        self.datePickerFechaFin.minimumDate = NSDate() as Date
        self.datePickerFechaFin.addTarget(self, action: #selector(AlarmaViewController.actualizarFechaFin), for: .valueChanged)
        textField.inputView = self.datePickerFechaFin
    }
    
    func actualizarFechaFin()
    {
        txtFechaFin.text = datePickerFechaFin.date.fechaString()
    }
    
    // #pragma mark - textField
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool
    {
        textField.resignFirstResponder()
        return true
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        animateViewMoving(up: true, moveValue: 120)
        
        if textField.tag == 1
        {
            if textField.text == ""
            {
                textField.text = model.tiposRecordatorio[0].nombreTipo
            }
        }
        
        if textField.tag == 4
        {
            if textField.text == ""
            {
                textField.text = model.frecuenciasRecordatorio[0].nombreFrecuencia
            }
        }
        
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        animateViewMoving(up: false, moveValue: 120)
        
        if textField.tag == 1
        {
            modelUsuario.alertaMascota.tipoRecordatorio = textField.text
        }
        
        if textField.tag == 2
        {
            modelUsuario.alertaMascota.nombre = textField.text
        }
        
        if textField.tag == 3
        {
            modelUsuario.alertaMascota.hora = textField.text
        }
        
        if textField.tag == 4
        {
            modelUsuario.alertaMascota.frecuencia = textField.text
        }
        
        if textField.tag == 5
        {
            modelUsuario.alertaMascota.fechaInicio = textField.text
        }
        
        if textField.tag == 6
        {
            modelUsuario.alertaMascota.fechaFin = textField.text
        }
    }
    
    @IBAction func cancelar(_ sender: Any)
    {
        let alert:UIAlertController = UIAlertController(title: "¡Confirmar!", message: "¿Está seguro de abandonar la vista?", preferredStyle: .alert)
        
        let continuarAction = UIAlertAction(title: "Sí", style: .default)
        {
            UIAlertAction in self.abandonar()
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .cancel)
        {
            UIAlertAction in
        }
        
        // Add the actions
        alert.addAction(continuarAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    func abandonar()
    {
        modelUsuario.alertaMascota.activada = false
        modelUsuario.alertaMascota.fechaFin = ""
        modelUsuario.alertaMascota.fechaInicio = ""
        modelUsuario.alertaMascota.frecuencia = ""
        modelUsuario.alertaMascota.hora = ""
        modelUsuario.alertaMascota.idAlerta = ""
        modelUsuario.alertaMascota.nombre = ""
        modelUsuario.alertaMascota.tipoRecordatorio = ""
        
        dismiss(animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool)
    {
        super.viewWillAppear(animated)
        
        Comando.getTiposRecordatorio()
        Comando.getFrecuenciasRecordatorio()
        
        NotificationCenter.default.addObserver(self, selector: #selector(AlarmaViewController.cargarDatos(_:)), name:NSNotification.Name(rawValue:"cargoTiposRecordatorio"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(AlarmaViewController.cargarDatos(_:)), name:NSNotification.Name(rawValue:"cargoFrecuenciasRecordatorio"), object: nil)
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
    
    // Button Cancelar Keyboard
    func cancelClick()
    {
        view.endEditing(true)
    }
}
