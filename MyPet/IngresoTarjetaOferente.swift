//
//  IngresoTarjetaOferente.swift
//  MyPet
//
//  Created by Andres Garcia on 8/21/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class IngresoTarjetaOferente: UIViewController,  UITextFieldDelegate{
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeField: UITextField?
    
    
    @IBOutlet weak var numeroTarjeta: UITextField!
    
    @IBOutlet weak var nombre: UITextField!
    
    @IBOutlet weak var mes: UITextField!
    
    @IBOutlet weak var ano: UITextField!
    
    @IBOutlet weak var codSeguridad: UITextField!
    
    @IBOutlet weak var cuotas: UITextField!
    
    let model = ModeloOferente.sharedInstance
    
    // View de espera
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    ///////////
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        registerForKeyboardNotifications()
        
        let tarjeta =  model.tpaga.getTarjetaActiva()
        
        if tarjeta == nil {
            return
        }
        
       numeroTarjeta.text = "**** **** **** " + tarjeta!.numero
       nombre.text = "****** ******"
       mes.text = "**"
       ano.text = "****"
       codSeguridad.text = "***"
       cuotas.text = String(tarjeta!.cuotas)
 
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        activityIndicator.removeFromSuperview()
        messageFrame.removeFromSuperview()
    }
    
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func didTapFinalizar(_ sender: Any) {
        
        /// Validar si el usuaio hizo cambios 
        if noHuboCambios() {
            
             dismiss(animated: true, completion: nil)
             return
        }
        
        
        ///1. Revisamos errores obvios
        
        let res = evaluarErrores()
        
        if res.mensaje != "" {
            let alerta = UIAlertController(title: "Información Incompleta ", message: res.mensaje, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                
                return
            }
            
            alerta.addAction(OKAction)
            present(alerta, animated: true, completion: { return })
            return
            
        }
        
        progressBarDisplayer(msg: "Registro", indicator: true)
        
        
        ///2. Creamos la tarjeta
        var tarjeta  = TPTarjeta()
        
        tarjeta.cardHolderName = nombre.text!
        tarjeta.expirationMonth = mes.text!
        tarjeta.expirationYear = ano.text!
        tarjeta.cvc = codSeguridad.text!
        tarjeta.primaryAccountNumber = numeroTarjeta.text!
        
        
        TPTarjeta.crearTarjetaEnTpaga(tarjeta: tarjeta, completion:  {(token, error) in
            
            
            if let err = error as? TPagaError {
                switch err {
                    
                case .camposErroneos :
                    print("Falta o sobra algún campo o el número de caracteres de  algún campo en muy pequeño o muy grande")
                    self.mostrarMensajeOk(titulo: "Error", msg: "Fallo al intentar la operación. Cod: CE")
                case .noJson :
                    print("No pudo parsear el json")
                    self.mostrarMensajeOk(titulo: "Error", msg: "Fallo al intentar la operación. Cod: PJS")
                case .noAutorizado :
                    print("No hay autorizacion ")
                    self.mostrarMensajeOk(titulo: "Error", msg: "Fallo al intentar la operación. Cod: NHA")
                case .desconocido :
                    print("error desconocido")
                    self.mostrarMensajeOk(titulo: "Error", msg: "Fallo al intentar la operación. Cod: ED")
                default:
                    print("error no esperado")
                    self.mostrarMensajeOk(titulo: "Error", msg: "Fallo al intentar la operación. Cod: ENE")
                }
                return
            }
            
            
            if let err = error as? SerializacionError{
                switch err {
                case .missing(let mensaje) :
                    print("Falta: \(mensaje)")
                    self.mostrarMensajeOk(titulo: "Error", msg: "Fallo al intentar la operación. F: \(mensaje)")
                case .invalid(let nombre, let dat) :
                    print("Invalido: \(nombre): \(dat)")
                    self.mostrarMensajeOk(titulo: "Error", msg: "Fallo al intentar la operación. I: \(nombre): \(dat)")
                }
                return
            }
            
            
            if error != nil {
                print(error!.localizedDescription)
                self.mostrarMensajeOk(titulo: "Error", msg: "Revisa tu conección a internet y vuelve a intentar")
                return
            }
            
            print("temporal:   " + token!)
            
            
            
            
            
            
            //3.  Si hubo exito al crear la tarjeta entonces de una vez asociamos la tarjeta al cliente
            TPCliente.asociarTarjeta2Cliente(idCliente: self.model.tpaga.idClienteEnTpaga, token: token!, completion: {(defToken, lastFour, error) in
                
                
                if let err = error as? TPagaError {
                    switch err {
                    case .idClienteNoExiste :
                        print("cliente no existe")
                        self.mostrarMensajeOk(titulo: "Error", msg: "Fallo al intentar la operación. Cod: CNE")
                    case .noAutorizado :
                        print("No hay autorización")
                        self.mostrarMensajeOk(titulo: "Error", msg: "Fallo al intentar la operación. Cod: NHA")
                    case .desconocido :
                        print("error desconocido")
                        self.mostrarMensajeOk(titulo: "Error", msg: "Fallo al intentar la operación. Cod: ED")
                    default:
                        print("error no esperado")
                        self.mostrarMensajeOk(titulo: "Error", msg: "Fallo al intentar la operación. Cod: ENE")
                    }
                    return
                }
                
                
                if let err = error as? SerializacionError {
                    switch err {
                    case .missing(let mensaje) :
                        print("Falta: \(mensaje)")
                        self.mostrarMensajeOk(titulo: "Error", msg: "Fallo al intentar la operación. F: \(mensaje)")
                    case .invalid(let nombre, let dat) :
                        print("Invalido: \(nombre): \(dat)")
                        self.mostrarMensajeOk(titulo: "Error", msg: "Fallo al intentar la operación. I: \(nombre): \(dat)")
                    }
                    return
                }
                
                
                if error != nil {
                    print(error!.localizedDescription)
                    self.mostrarMensajeOk(titulo: "Error", msg: "Revisa tu conección a internet y vuelve a intentar")
                    return
                }
                
                // De aqui pa abajo ya deberia estar  bien la respuesta
                print(defToken!)     // Con este token es con el que se hacen los cargos a la tarjeta. Toca guardarlo en firebase.
                
                
                /* guard let user = FIRAuth.auth()?.currentUser else {
                    self.performSegue(withIdentifier: "irFinalizar", sender: self)
                    return
                }*/
                
                
                self.model.tpaga.desactivarTodasTarjetas(uid: self.model.idOferente)
                let franq = self.model.tpaga.getCreditCardType(numberOnly: self.numeroTarjeta.text!)
                
                let id = ComandoOferente.crearTarjeta(uid: self.model.idOferente, lastFour: lastFour!, token: defToken!, cuotas: Int(self.cuotas.text!)!, franquicia: franq.rawValue
                    , activo: true)
                
                let mini = MiniTarjeta()
                mini.activa = true
                mini.cuotas = Int(self.cuotas.text!)!
                mini.franquicia = franq.rawValue
                mini.id = id
                mini.numero = lastFour!
                mini.token = defToken!
                
                self.model.tpaga.adicionarMiniTarjeta(mini:mini)
                
                
                DispatchQueue.main.async {
                    () -> Void in
                    
                    self.activityIndicator.removeFromSuperview()
                    self.messageFrame.removeFromSuperview()
                    
                    if self.model.tpaga.vistaInicioCreacionTarjeta == "PEDIDO" {
                        self.performSegue(withIdentifier: "irFinalizar", sender: self)
                        return
                    }
                    
                    if self.model.tpaga.vistaInicioCreacionTarjeta == "FINALIZAR" {
                        self.performSegue(withIdentifier: "irFinalizar", sender: self)
                        return
                    }
                    
                    if self.model.tpaga.vistaInicioCreacionTarjeta == "LISTATARJETAS" {
                        self.performSegue(withIdentifier: "goTarjetas", sender: self)
                        return
                    }
                }
                
                
            })
            
        })
        
    }
    
    func noHuboCambios() -> Bool {
        
        let tarjeta =  model.tpaga.getTarjetaActiva()
        
        if tarjeta == nil {
            return false
        }
        
        if numeroTarjeta.text == "**** **** **** " + tarjeta!.numero && nombre.text == "****** ******" &&  mes.text == "**" && ano.text == "****" && codSeguridad.text == "***" {
            
            return true
            
        }

        return false
        
    }
    
    
    
    func evaluarErrores() -> (mensaje:String, isMortal:Bool ){
        
        
        var mensaje  = ""
        var falloMortal = true
        
        if !lunhsTest(number: (numeroTarjeta.text?.quitarEspacios())!) {
            numeroTarjeta.becomeFirstResponder()
            mensaje = "El número de la tarjeta es incorrecto"
            
            falloMortal = true
            return (mensaje, falloMortal)
        }
        
        if  (numeroTarjeta.text?.quitarEspacios().characters.count)! < 13 || (numeroTarjeta.text?.quitarEspacios().characters.count)! > 19
        {
            numeroTarjeta.becomeFirstResponder()
            mensaje = "El número de la tarjeta es incorrecto"
            
            falloMortal = true
            return (mensaje, falloMortal)
        }
        
        
        if (nombre.text?.characters.count)! < 3 {
            nombre.becomeFirstResponder()
            mensaje = "Por favor asegurate de ingresar tu nombre"
            
            falloMortal = true
            return (mensaje, falloMortal)
        }
        
        if !isNumeroDeMes(testStr: mes.text!) {
            mes.becomeFirstResponder()
            mensaje = "Asegúrate que el mes sea un número entre 1 y 12"
            
            falloMortal = true
            return (mensaje, falloMortal)
            
        }
        
        if !isYearNoMayorDeDiezHaciaFuturo(testStr: ano.text!) {
            ano.becomeFirstResponder()
            mensaje = "Asegúrate que el año sea un número de 4 cifras y que sea el año correcto."
            
            falloMortal = true
            return (mensaje, falloMortal)
        }
        
        if !isUnCvs(testStr: codSeguridad.text!) {
            codSeguridad.becomeFirstResponder()
            mensaje = "Asegúrate que el cvs sea un número de 3 o 4 cifras"
            
            falloMortal = true
            return (mensaje, falloMortal)
        }
        
        if !isCantidadCuotas(cuotas: cuotas.text!) {
            cuotas.becomeFirstResponder()
            mensaje = "Asegúrate que las cuotas sea un número entre 1 y 36"
            
            falloMortal = true
            return (mensaje, falloMortal)
            
            
        }
        
        
        return (mensaje, falloMortal)
        
    }
    
    
    func mostrarMensajeOk(titulo:String, msg:String) {
        
        DispatchQueue.main.async {
            
            self.activityIndicator.removeFromSuperview()
            self.messageFrame.removeFromSuperview()
            
            let alerta = UIAlertController(title: titulo, message: msg, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                
                return
            }
            
            alerta.addAction(OKAction)
            self.present(alerta, animated: true, completion: { return })
        }
        
    }
    
    
    
    
    func isNumero(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let placaRegEx = "^[0-9]*$"
        
        let placaTest = NSPredicate(format:"SELF MATCHES %@", placaRegEx)
        return placaTest.evaluate(with: testStr)
    }
    
    
    // debe ser un numero entre 1 y 12 pero permite ej:03 que seria "marzo"
    func isNumeroDeMes(testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let placaRegEx = "^(?:[1-9]|0[1-9]|10|11|12)"
        
        let placaTest = NSPredicate(format:"SELF MATCHES %@", placaRegEx)
        return placaTest.evaluate(with: testStr)
    }
    
    
    
    
    
    func isYearNoMayorDeDiezHaciaFuturo(testStr:String) -> Bool {
        
        guard let year = Int(testStr) else {
            return false
        }
        
        let calendar = NSCalendar.init(calendarIdentifier: NSCalendar.Identifier.gregorian)
        let currentYear = (calendar?.component(NSCalendar.Unit.year, from: Date()))!
        
        if year < currentYear || year - currentYear > 10 {
            return false
        }
        
        return true
        
    }
    
    
    
    
    func isUnCvs(testStr:String) -> Bool {  // Pueden tener 3 o 4 digitos
        // println("validate calendar: \(testStr)")
        let placaRegEx = "^[0-9][0-9][0-9]|[0-9][0-9][0-9][0-9]"
        
        let placaTest = NSPredicate(format:"SELF MATCHES %@", placaRegEx)
        return placaTest.evaluate(with: testStr)
    }
    
    
    
    func isCantidadCuotas(cuotas:String) -> Bool {
        
        guard let cuotas = Int(cuotas) else {
            return false
        }
        
        
        if cuotas > 36 || cuotas < 1  {
            return false
        }
        
        return true
        
        
    }
    
    //method: 2 - short
    func lunhsTest(number: String) -> Bool {
        
        guard Int(number) != nil   else {
            return false
        }
        
        var sum = 0
        let reversedInts = number.characters.reversed().map {Int(String($0))!}
        for (index, value) in reversedInts.enumerated() {
            sum += ((index % 2 == 1) ? (value == 9 ? 9 : (value * 2) % 9) : value)
        }
        
        return sum > 0 ? sum % 10 == 0 : false
    }
    
    
    
    
    func registerForKeyboardNotifications(){
        //Adding notifies on keyboard appearing
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWasShown(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillBeHidden(notification:)), name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func deregisterFromKeyboardNotifications(){
        //Removing notifies on keyboard appearing
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillShow, object: nil)
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name.UIKeyboardWillHide, object: nil)
    }
    
    func keyboardWasShown(notification: NSNotification){
        //Need to calculate keyboard exact size due to Apple suggestions
        self.scrollView.isScrollEnabled = true
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, keyboardSize!.height, 0.0)
        
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        
        var aRect : CGRect = self.view.frame
        aRect.size.height -= keyboardSize!.height
        if let activeField = self.activeField {
            if (!aRect.contains(activeField.frame.origin)){
                self.scrollView.scrollRectToVisible(activeField.frame, animated: true)
            }
        }
    }
    
    func keyboardWillBeHidden(notification: NSNotification){
        //Once keyboard disappears, restore original positions
        var info = notification.userInfo!
        let keyboardSize = (info[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue.size
        let contentInsets : UIEdgeInsets = UIEdgeInsetsMake(0.0, 0.0, -keyboardSize!.height, 0.0)
        self.scrollView.contentInset = contentInsets
        self.scrollView.scrollIndicatorInsets = contentInsets
        self.view.endEditing(true)
        
        self.scrollView.isScrollEnabled = false
    }
    
    
    func textFieldDidBeginEditing(_ textField: UITextField)
    {
        activeField = textField
    }
    
    func textFieldDidEndEditing(_ textField: UITextField)
    {
        activeField = nil
        
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    func progressBarDisplayer(msg:String,  indicator:Bool ) {
        
        messageFrame = UIView(frame: CGRect(x: view.frame.midX - 90, y: view.frame.midY - 50 , width: 180, height: 100))
        messageFrame.layer.cornerRadius = 15
        messageFrame.backgroundColor = UIColor(white: 0, alpha: 0.3)
        if indicator {
            activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.whiteLarge)
            activityIndicator.frame = CGRect(x: 40, y: 0, width: 100, height: 100)
            activityIndicator.startAnimating()
            activityIndicator.color = UIColor.white
            messageFrame.addSubview(activityIndicator)
        }
        view.addSubview(messageFrame)
        
    }
    
    
    
    
}
