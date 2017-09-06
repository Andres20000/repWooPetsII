//
//  AlarmaViewController.swift
//  MyPet
//
//  Created by Jose Aguilar on 10/07/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit
import FirebaseAuth
import UserNotifications

class AlarmaViewController: UIViewController, UIPickerViewDelegate, UITextFieldDelegate
{
    let model = Modelo.sharedInstance
    let modelUsuario = ModeloUsuario.sharedInstance
    let  user = FIRAuth.auth()?.currentUser
    
    let pickerTipoRecordatorio = UIPickerView()
    let pickerFrecuencia = UIPickerView()
    
    var datePickerHora = UIDatePicker()
    var horaAlarma:Date? = nil
    
    var datePickerFechaInicio = UIDatePicker()
    var fechaInicio:Date? = nil
    
    var datePickerFechaFin = UIDatePicker()
    var fechaFin:Date? = nil
    
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
        
        modelUsuario.alertaMascota.activada = true
        modelUsuario.alertaMascota.idMascota = modelUsuario.tuMascota.idMascota
        
        modelUsuario.alertaMascota.idAlerta = ComandoUsuario.crearIdAlertaMascotaUsuario(uid: (user?.uid)!, idMascota: modelUsuario.alertaMascota.idMascota)
        
        if #available(iOS 10.0, *)
        {
            UNUserNotificationCenter.current().delegate = self as? UNUserNotificationCenterDelegate
        } else
        {
            // Fallback on earlier versions
        }
        
        //cancelarTodasLasNotificaciones()
    }
    
    func printNotificaciones()
    {
        if #available(iOS 10.0, *)
        {
            let center = UNUserNotificationCenter.current()
            center.getPendingNotificationRequests(completionHandler: { requests in
                for request in requests {
                    print(request.identifier)
                    print(request.trigger)
                }
            })
        } else {
            // Fallback on earlier versions
        }
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
            
            txtFechaFin.text = ""
            
            modelUsuario.alertaMascota.fechaFin = txtFechaFin.text
        }
    }
    
    // #pragma mark - DatePicker
    
    func pickUpDateHora(_ textField : UITextField)
    {
        // DatePicker
        self.datePickerHora = UIDatePicker(frame:CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: 216))
        self.datePickerHora.backgroundColor = UIColor.white
        self.datePickerHora.datePickerMode = UIDatePickerMode.time
        self.datePickerHora.minuteInterval = 5
        self.datePickerHora.addTarget(self, action: #selector(AlarmaViewController.actualizarHora), for: .valueChanged)
        textField.inputView = self.datePickerHora
    }
    
    func actualizarHora()
    {
        horaAlarma = datePickerHora.date
        txtHora.text = horaAlarma?.horaString()
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
        fechaInicio = datePickerFechaInicio.date
        txtFechaInicio.text = fechaInicio?.fechaString()
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
        fechaFin = datePickerFechaFin.date
        txtFechaFin.text = fechaFin?.fechaString()
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
                modelUsuario.alertaMascota.tipoRecordatorio = model.tiposRecordatorio[0].nombreTipo
                
                textField.text = modelUsuario.alertaMascota.tipoRecordatorio
            }
        }
        
        if textField.tag == 3
        {
            if textField.text == ""
            {
                horaAlarma = datePickerHora.date
                
                textField.text = horaAlarma?.horaString()
                
                modelUsuario.alertaMascota.hora = textField.text
            }
        }
        
        if textField.tag == 4
        {
            if textField.text == ""
            {
                modelUsuario.alertaMascota.frecuencia = model.frecuenciasRecordatorio[0].nombreFrecuencia
                
                textField.text = modelUsuario.alertaMascota.frecuencia
            }
        }
        
        if textField.tag == 5
        {
            if textField.text == ""
            {
                fechaInicio = datePickerFechaInicio.date
                
                textField.text = fechaInicio?.fechaString()
                
                modelUsuario.alertaMascota.fechaInicio = textField.text
            }
        }
        
        if textField.tag == 6
        {
            if textField.text == ""
            {
                fechaFin = datePickerFechaFin.date
                
                textField.text = fechaFin?.fechaString()
                
                modelUsuario.alertaMascota.fechaFin = textField.text
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
            if modelUsuario.alertaMascota.frecuencia == "" || modelUsuario.alertaMascota.fechaInicio == ""
            {
                mostrarAlerta(titulo: "¡Advertencia!", mensaje: "Debes diligenciar la Frecuencia y Fecha de inicio de la alarma")
                
                textField.text = ""
                
                modelUsuario.alertaMascota.fechaFin = textField.text
                
            } else
            {
                if modelUsuario.alertaMascota.frecuencia == "Anual"
                {
                    let yearDate = Comando.calcularFechaEnAños(fecha1: fechaFin! as NSDate, fecha2: fechaInicio! as NSDate)
                    
                    if yearDate < 1
                    {
                        mostrarAlerta(titulo: "¡Advertencia!", mensaje: "El tiempo entre la fecha inicio y la fecha fin debe ser mayor o igual a 1 año")
                        
                        textField.text = ""
                        
                        modelUsuario.alertaMascota.fechaFin = textField.text
                        
                        return
                    }
                }
                
                if modelUsuario.alertaMascota.frecuencia == "Bimensual"
                {
                    let monthDate = Comando.calcularFechaEnMeses(fecha1: fechaFin! as NSDate, fecha2: fechaInicio! as NSDate)
                    
                    if monthDate < 2
                    {
                        mostrarAlerta(titulo: "¡Advertencia!", mensaje: "El tiempo entre la fecha inicio y la fecha fin debe ser mayor o igual a 2 meses")
                        
                        textField.text = ""
                        
                        modelUsuario.alertaMascota.fechaFin = textField.text
                        
                        return
                    }
                }
                
                if modelUsuario.alertaMascota.frecuencia == "Diaria"
                {
                    let dayDate = Comando.calcularFechaEnDias(fecha1: fechaFin! as NSDate, fecha2: fechaInicio! as NSDate)
                    
                    if dayDate < 1
                    {
                        mostrarAlerta(titulo: "¡Advertencia!", mensaje: "El tiempo entre la fecha inicio y la fecha fin debe ser mayor o igual a 1 día")
                        
                        textField.text = ""
                        
                        modelUsuario.alertaMascota.fechaFin = textField.text
                        
                        return
                    }
                }
                
                if modelUsuario.alertaMascota.frecuencia == "Mensual"
                {
                    let monthDate = Comando.calcularFechaEnMeses(fecha1: fechaFin! as NSDate, fecha2: fechaInicio! as NSDate)
                    
                    if monthDate < 1
                    {
                        mostrarAlerta(titulo: "¡Advertencia!", mensaje: "El tiempo entre la fecha inicio y la fecha fin debe ser mayor o igual a 1 mes")
                        
                        textField.text = ""
                        
                        modelUsuario.alertaMascota.fechaFin = textField.text
                        
                        return
                    }
                }
                
                if modelUsuario.alertaMascota.frecuencia == "Quincenal"
                {
                    let dayDate = Comando.calcularFechaEnDias(fecha1: fechaFin! as NSDate, fecha2: fechaInicio! as NSDate)
                    
                    if dayDate < 14
                    {
                        mostrarAlerta(titulo: "¡Advertencia!", mensaje: "El tiempo entre la fecha inicio y la fecha fin debe ser mayor o igual a 15 días")
                        
                        textField.text = ""
                        
                        modelUsuario.alertaMascota.fechaFin = textField.text
                        
                        return
                    }
                }
                
                if modelUsuario.alertaMascota.frecuencia == "Semanal"
                {
                    let dayDate = Comando.calcularFechaEnDias(fecha1: fechaFin! as NSDate, fecha2: fechaInicio! as NSDate)
                    
                    if dayDate < 7
                    {
                        mostrarAlerta(titulo: "¡Advertencia!", mensaje: "El tiempo entre la fecha inicio y la fecha fin debe ser mayor o igual a 7 días")
                        
                        textField.text = ""
                        
                        modelUsuario.alertaMascota.fechaFin = textField.text
                        
                        return
                    }
                }
                
                modelUsuario.alertaMascota.fechaFin = textField.text
            }
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
        modelUsuario.alertaMascota.idMascota = ""
        modelUsuario.alertaMascota.nombre = ""
        modelUsuario.alertaMascota.tipoRecordatorio = ""
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func crearAlarma(_ sender: Any)
    {
        view.endEditing(true)
        
        print("\(modelUsuario.alertaMascota.activada!) - \(modelUsuario.alertaMascota.fechaFin!) - \(modelUsuario.alertaMascota.fechaInicio!) - \(modelUsuario.alertaMascota.frecuencia!) - \(modelUsuario.alertaMascota.hora!) - \(modelUsuario.alertaMascota.idAlerta!) - \(modelUsuario.alertaMascota.nombre!) - \(modelUsuario.alertaMascota.tipoRecordatorio!) - \(modelUsuario.alertaMascota.idMascota!)")
        
        if modelUsuario.alertaMascota.fechaFin == "" || modelUsuario.alertaMascota.fechaInicio == "" || modelUsuario.alertaMascota.frecuencia == "" || modelUsuario.alertaMascota.hora == "" || modelUsuario.alertaMascota.nombre == "" || modelUsuario.alertaMascota.tipoRecordatorio == ""
        {
            mostrarAlerta(titulo: "¡Advertencia!", mensaje: "Debes completar todos los campos para poder continuar")
        } else
        {
            ComandoUsuario.crearEditarAlertaMascota(uid: (user?.uid)!, alerta: modelUsuario.alertaMascota)
            
            var frecuenciaAlarma:Frecuencia? = nil
            
            if modelUsuario.alertaMascota.frecuencia == "Anual"
            {
                frecuenciaAlarma = .anual
            }
            
            if modelUsuario.alertaMascota.frecuencia == "Bimensual"
            {
                frecuenciaAlarma = .bimensual
            }
            
            if modelUsuario.alertaMascota.frecuencia == "Diaria"
            {
                frecuenciaAlarma = .diaria
            }
            
            if modelUsuario.alertaMascota.frecuencia == "Mensual"
            {
                frecuenciaAlarma = .mensual
            }
            
            if modelUsuario.alertaMascota.frecuencia == "Quincenal"
            {
                frecuenciaAlarma = .quincenal
            }
            
            if modelUsuario.alertaMascota.frecuencia == "Semanal"
            {
                frecuenciaAlarma = .semanal
            }
            
            crearNotificaciones(id: modelUsuario.alertaMascota.idAlerta!, inicio: combineDateAndTime(date: fechaInicio!, time: horaAlarma!), fin: combineDateAndTime(date: fechaFin!, time: horaAlarma!), titulo: modelUsuario.alertaMascota.tipoRecordatorio!, subtitulo: "", cuerpo: modelUsuario.alertaMascota.nombre!, frecuencia: frecuenciaAlarma!)
            
            printNotificaciones()
            
            self .abandonar()
        }
    }
    
    func crearNotificaciones(id:String, inicio:Date, fin:Date, titulo:String, subtitulo: String, cuerpo:String, frecuencia:Frecuencia)
    {
        let fechas = calcularFechas(inicio: inicio, fin: fin, frecuencia: frecuencia)
        
        let calendar = NSCalendar.current
        
        if #available(iOS 10.0, *)
        {
            let content = UNMutableNotificationContent()
            
            content.title = titulo
            content.subtitle = subtitulo
            content.body = cuerpo
            content.sound = UNNotificationSound.default()
            
            print(fechas)
            
            var i = 0
            for fecha in fechas
            {
                print(fecha)
                let componentes = calendar.dateComponents([.year, .month, .day, .hour, .minute], from: fecha)
                print("dia" + String(componentes.day!))
                
                
                let trigger = UNCalendarNotificationTrigger(dateMatching: componentes, repeats: false)
                
                let request = UNNotificationRequest(identifier: id + String(i), content: content, trigger: trigger)
                
                
                UNUserNotificationCenter.current().add(request) { error in
                    if (error != nil){
                        
                        print("No logró adicionar la notificación")
                        print(error!.localizedDescription)
                    }
                    
                }
                
                i += 1
                
                if i == 12
                {
                    break
                }
            }
        } else
        {
            // Fallback on earlier versions
        }
    }
    
    func calcularFechas(inicio:Date, fin:Date, frecuencia:Frecuencia) -> [Date]
    {
        var fechas:[Date] = []
        
        fechas.append(inicio);
        var fechaActual = inicio;
        let fechafin = sumarFrecuencia(fecha: fin, frecuencia: .diaria)
        
        while fechaActual <= fin {
            fechaActual = sumarFrecuencia(fecha: fechaActual, frecuencia: frecuencia)
            if fechaActual <= fechafin {
                fechas.append(fechaActual)
            }
        }
        
        return fechas
    }
    
    func sumarFrecuencia(fecha:Date, frecuencia:Frecuencia) -> Date
    {
        var dateComponent = DateComponents()
        
        if frecuencia == .minutos {
            dateComponent.minute = 1
        }
        
        if frecuencia == .diaria {
            dateComponent.day = 1
        }
        
        if frecuencia == .semanal {
            dateComponent.day = 7
        }
        
        if frecuencia == .quincenal {
            dateComponent.day = 14
        }
        
        if frecuencia == .mensual {
            dateComponent.month = 1
        }
        
        if frecuencia == .bimensual {
            dateComponent.month = 2
        }
        if frecuencia == .anual {
            dateComponent.year = 1
        }
        
        let futureDate = Calendar.current.date(byAdding: dateComponent, to: fecha)
        
        
        return futureDate!
        
    }
    
    func cancelarNotificaciones(id:String)
    {
        var lista:[String] = []
        
        for i in (0...64) {
            lista.append(id + String(i))
        }
        
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: lista)
        } else {
            // Fallback on earlier versions
        }
    }
    
    func cancelarTodasLasNotificaciones()
    {
        if #available(iOS 10.0, *) {
            UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        } else {
            // Fallback on earlier versions
        }
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
        let cancelButton = UIBarButtonItem(title: "Ok", style: .plain, target: self, action: #selector(RegistroOferenteViewController.cancelClick))
        toolBar.setItems([spaceButton, cancelButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        textField.inputAccessoryView = toolBar
    }
    
    // Button Cancelar Keyboard
    func cancelClick()
    {
        view.endEditing(true)
    }
    
    func combineDateAndTime(date: Date, time: Date) -> Date
    {
        let calendar = NSCalendar.current
        
        let dateComponents = calendar.dateComponents([.year, .month, .day], from: date)
        let timeComponents = calendar.dateComponents([.hour, .minute, .second], from: time)
        
        var components = DateComponents()
        components.year = dateComponents.year
        components.month = dateComponents.month
        components.day = dateComponents.day
        components.hour = timeComponents.hour
        components.minute = timeComponents.minute
        components.second = timeComponents.second
        
        return calendar.date(from: components)!
    }
}

extension ViewController: UNUserNotificationCenterDelegate
{
    @available(iOS 10.0, *)
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.alert])
    }
    
}

enum Frecuencia:Int
{
    case minutos
    case diaria
    case semanal
    case quincenal
    case mensual
    case bimensual
    case anual
    
    
}
