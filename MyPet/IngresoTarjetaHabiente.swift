//
//  IngresoTarjetaHabiente.swift
//  MyPet
//
//  Created by Andres Garcia on 8/21/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit
import Firebase

class IngresoTarjetaHabiente: UIViewController , UITextFieldDelegate {
    
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    var activeField: UITextField?
    
    
    @IBOutlet weak var telefono: UITextField!
    
        
    @IBOutlet weak var nombre: UITextField!
    
    @IBOutlet weak var apellido: UITextField!
    
    
    @IBOutlet weak var correo: UITextField!
    
    
    //@IBOutlet weak var direccion: UITextField!
    
    //@IBOutlet weak var pais: UITextField!
    
    //@IBOutlet weak var ciudad: UITextField!
    
    @IBOutlet weak var botonFianalizar: UIButton!
    @IBOutlet weak var vistaMetodoPago: UIView!
    
    @IBOutlet weak var valor: UILabel!
    
    @IBOutlet weak var tarjeta: UILabel!
    
    
    var inicialesPais = "CO"
    
    let model = ModeloOferente.sharedInstance
    
    
    // View de espera
    var messageFrame = UIView()
    var activityIndicator = UIActivityIndicatorView()
    ///////////

    var publicacion:PublicacionOferente?
    

    override func viewDidLoad() {
        super.viewDidLoad()

        // TODO precargar datos existente
        
        
        botonFianalizar.layer.cornerRadius = 20.0
        vistaMetodoPago.layer.cornerRadius = 15.0
        registerForKeyboardNotifications()
        
        
        nombre.text = model.tpaga.nombre
        apellido.text = model.tpaga.apellido
        telefono.text = model.tpaga.telefono
        correo.text = model.tpaga.correo
        valor.text = String(model.params.valorDestacado).convertToMoney()
        
        

        
        
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

    }
    
    override func viewWillDisappear(_ animated: Bool) {
        deregisterFromKeyboardNotifications()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        activityIndicator.removeFromSuperview()
        messageFrame.removeFromSuperview()
        let tarjeta =  model.tpaga.getTarjetaActiva()
        
        if tarjeta != nil {
            self.tarjeta.text = "Tarjeta de crédito terminada en " + tarjeta!.numero
        }
        
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    
    @IBAction func didTapSiguiente(_ sender: Any) {
        
        
        
        
        //Validaciones Basicas
        
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
        
        
        //Validar si hubo modificacion.
        if noHuboCambios() {
            self.performSegue(withIdentifier: "confirmarTarjeta", sender: self)
            return 
            
        }

        
        progressBarDisplayer(msg: "", indicator: true)
        
        //Intentamos crearlo en TPaga
        var cli  = TPCliente()
        
        cli.merchantCustomerId = model.idOferente
        cli.firstName = nombre.text!
        cli.lastName = apellido.text!
        cli.email = correo.text!
        
        
        
        // cli.ciudad = ciudad.text!
        //cli.direccion = direccion.text!
        //cli.inicialesPais = inicialesPais
        
        
        
        
        TPCliente.crearClienteEnTpaga(cliente: cli, completion:  {(idCliente, error) in
            
            
            if let err = error as? TPagaError {
                switch err {
                    
                case .camposErroneos:
                    print("Campos enviados erroneos")
                    self.mostrarMensajeOk(titulo: "Error", msg: "Fallo al intentar la operación. Cod: CER")
                case .noJson :
                    print("No pudo parsear el json")
                    self.mostrarMensajeOk(titulo: "Error", msg: "Fallo al intentar la operación. Cod: PJS")
                case .idClienteNoExiste :
                    print("cliente no existe")
                    self.mostrarMensajeOk(titulo: "Error", msg: "Fallo al intentar la operación. Cod: CNE")
                case .noAutorizado :
                    print("No hay autorizacion ")
                    self.mostrarMensajeOk(titulo: "Error", msg: "Fallo al intentar la operación. Cod: NHA")
                case .desconocido :
                    print("error desconocido")
                    self.mostrarMensajeOk(titulo: "Error", msg: "Fallo al intentar la operación. Cod: ED")
                case .rechazada(let motivo):
                    self.mostrarMensajeOk(titulo: "Error", msg: motivo + "Puedes intentar con otra tarjeta o pagar en efectivo")
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
            
            
            // En teoria de aqui pa abajo ya esta bien la respuesta
            print(idCliente!)
            
           
            
            
            self.model.tpaga.idClienteEnTpaga = idCliente!
            self.model.tpaga.nombre = self.nombre.text!
            self.model.tpaga.apellido = self.apellido.text!
            self.model.tpaga.correo = self.correo.text!
            self.model.tpaga.telefono = self.telefono.text!
            
            
            ComandoOferente.setIdClienteTpaga(uid: self.model.idOferente , idClienteTpaga: idCliente!)
            
            ComandoOferente.setDatosTpaga(uid: self.model.idOferente)
            
            DispatchQueue.main.async {
                () -> Void in
                self.activityIndicator.removeFromSuperview()
                self.messageFrame.removeFromSuperview()
                self.performSegue(withIdentifier: "confirmarTarjeta", sender: self)
            }
            
        })
        
        
    }
    
    func noHuboCambios() -> Bool {
        
        let tpaga = model.tpaga
        if nombre.text != tpaga.nombre || apellido.text != tpaga.apellido || correo.text != tpaga.correo || telefono.text != tpaga.telefono {
            return false
        }
        return true
    }
    
    
    
    func evaluarErrores() -> (mensaje:String, isMortal:Bool ){
        
        
        
        var mensaje  = ""
        var falloMortal = true
        
        
        if (nombre.text?.characters.count)! < 3 {
            nombre.becomeFirstResponder()
            mensaje = "Por favor asegurate de ingresar tu nombre"
            
            falloMortal = true
            return (mensaje, falloMortal)
        }
        
        if (apellido.text?.characters.count)! < 3 {
            apellido.becomeFirstResponder()
            mensaje = "Por favor asegurate de ingresar tu apellido"
            
            falloMortal = true
            return (mensaje, falloMortal)
        }
        
        if !isValidEmail(testStr: correo.text!) {
            correo.becomeFirstResponder()
            mensaje = "Por favor asegurate de ingresar el correo correctamente"
            
            falloMortal = true
            return (mensaje, falloMortal)
        }
        
        /*if (direccion.text?.characters.count)! < 3 {
            direccion.becomeFirstResponder()
            mensaje = "Por favor asegurate de ingresar la dirección de facturaciòn de la tarjeta"
            
            falloMortal = true
            return (mensaje, falloMortal)
        }*/
        
        if (telefono.text?.characters.count)! != 10 {
            telefono.becomeFirstResponder()
            mensaje = "Por favor revisa el teléfono"
            
            falloMortal = true
            return (mensaje, falloMortal)
        }
        
        
        
        return (mensaje, falloMortal)
        
    }
    
    
    func mostrarMensajeOk(titulo:String, msg:String) {
        
        
        DispatchQueue.main.async {
            () -> Void in
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
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        
        if textField.tag == 100 {   // Si es el pais
            
            performSegue(withIdentifier: "verPaises", sender: self)
            return false
            
        }
        
        return true
        
    }
    
    
    
    func isValidEmail(testStr:String) -> Bool {
        // print("validate calendar: \(testStr)")
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
        
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
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let s = segue.identifier  {
            if (s == ""){
                //let detalle = segue.destination as! ListadoPaises
                //detalle.delegate = self
            }
            
        }
        
    }
    
    
    func pagarConTarjeta() {
        
        
        let tpaga = model.tpaga
        
        var pago = TPPago()
        pago.amount = model.params.valorDestacado
        pago.creditCard = tpaga.getTarjetaActiva()!.token
        pago.description = "Destacado de WooPets"
        pago.orderId = "ID___Orden"
        pago.taxAmount = 0
        pago.installments = tpaga.getTarjetaActiva()!.cuotas
        
        TPCliente.hacerPago(pago: pago, completion: {(autorizado,authorizationCode, paymentTransaction , idPago , error) in
            
            
            if let err = error as? TPagaError {
                switch err {
                case .idClienteNoExiste :
                    print("cliente no existe")
                    self.mostrarMensajeOk(titulo: "Error", msg: "Fallo al intentar la transacción. Cod: CNE")
                case .noAutorizado :
                    print("No hay autorización")
                    self.mostrarMensajeOk(titulo: "Error", msg: "Fallo al intentar la transacción. Cod: NHA")
                case .desconocido :
                    print("error desconocido")
                    self.mostrarMensajeOk(titulo: "Error", msg: "Fallo al intentar la transacción. Cod: ED")
                case .rechazada(let motivo):
                    self.mostrarMensajeOk(titulo: "Error", msg: motivo + ". Puedes intentar con otra tarjeta o pagar en efectivo")
                default:
                    print("error no esperado")
                    self.mostrarMensajeOk(titulo: "Error", msg: "Fallo al intentar la transacción. Cod: ENE")
                }
                return
            }
            
            
            if let err = error as? SerializacionError{
                switch err {
                case .missing(let mensaje) :
                    print("Falta: \(mensaje)")
                    self.mostrarMensajeOk(titulo: "Error", msg: "Fallo al intentar la transacción. F: \(mensaje)")
                case .invalid(let nombre, let dat) :
                    print("Invalido: \(nombre): \(dat)")
                    self.mostrarMensajeOk(titulo: "Error", msg: "Fallo al intentar la transacción. I: \(nombre): \(dat)")
                }
                return
            }
            
            
            
            if error != nil {
                print(error!.localizedDescription)
                self.mostrarMensajeOk(titulo: "Error", msg: "No fue posible el pago con la tarjeta, puedes probar con otra tarjeta o pagar en efectivo.")
                return
            }
            
            
            if autorizado! {
                tpaga.authorizationCode = authorizationCode!
                tpaga.paymentTransaction = paymentTransaction!
                tpaga.idPago = idPago!
                ComandoDestacados.destacarPublicacion(publicacion: self.publicacion!, newVersion: 1)
                ComandoOferente.activarDestacado(idPublicacion: self.publicacion!.idPublicacion!, idTarjeta: tpaga.getTarjetaActiva()!.id)
                
                return
            }
            
            self.mostrarMensajeOk(titulo: "Error", msg: "El pago con la tarjeta no fue aprobado, puedes probar con otra tarjeta o pagar en efectivo.")
            
            
        })
        
        
        
        
    }
    
    
    
    @IBAction func didTapFinalizarCompra(_ sender: Any) {
        
        //TODO hacer verificaciones antes de intentar hacer el pago.
        
        
        let connectedRef = FIRDatabase.database().reference(withPath: ".info/connected")
        
        connectedRef.observe(.value, with: { snapshot in
            if let connected = snapshot.value as? Bool, connected {
                self.finalizarYaRedAsegurada()
            } else {
                let alerta = UIAlertController(title: "Sin conexión", message: " No detectamos conexión a internet, por favor valida tu señal para poder enviar tu pedido.", preferredStyle: .alert)
                
                let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                    
                    return
                }
                
                alerta.addAction(OKAction)
                self.present(alerta, animated: true, completion: { return })
            }
        })
        
        
    }

    
    
    
    func finalizarYaRedAsegurada(){
        
        
        
        let res = evaluarErrores()
        
        if res.mensaje != "" {
            let alerta = UIAlertController(title: "Información Incompleta ", message: res.mensaje, preferredStyle: .alert)
            
            let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
                self.botonFianalizar.isEnabled = true
                self.botonFianalizar.alpha = 1.0
                
                return
            }
            
            alerta.addAction(OKAction)
            present(alerta, animated: true, completion: { return })
            
        }
        
        self.botonFianalizar.isEnabled = false
        self.botonFianalizar.alpha = 0.4
        
        
        
        
        let ultimaAd = "A punto de cargar a tu tarjeta una compra por valor de " + String(model.params.valorDestacado).convertToMoney() + ". Estas seguro?"
        
        let ultima = UIAlertController(title: "Confirma tu información", message: ultimaAd, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "Si", style: .default) { (action) in
            
            
            
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.mostrarExito), name:NSNotification.Name(rawValue: "pagoExitoso"), object: nil)
            
            NotificationCenter.default.addObserver(self, selector: #selector(self.mostrarFracaso), name:NSNotification.Name(rawValue: "pagoFallido"), object: nil)
            
            
            self.progressBarDisplayer(msg: "Realizando la Transacción", indicator: true)
            
            
            ///Realizamos el pago con la tarjeta
            
            self.pagarConTarjeta()
            
            
            return
        }
        
        let cancelAction = UIAlertAction(title: "No", style: .default) { (action) in
            
            self.botonFianalizar.isEnabled = true
            self.botonFianalizar.alpha = 1.0
            return
        }
        
        ultima.addAction(cancelAction)
        ultima.addAction(OKAction)
        present(ultima, animated: true, completion: { return })
        
        
        
    }
    
    
    func mostrarExito() {
        
        
        FIRAnalytics.logEvent(withName: "Compro_Destacado", parameters: ["Valor" : model.params.valorDestacado as NSObject])
        DispatchQueue.main.async {
            
            self.performSegue(withIdentifier: "mostrarExito", sender: self)
        }
        
        
    }
    
    
    
    func mostrarFracaso() {
        
        let mensaje = "Tu pedido no se pudo enviar. Asegurate que tienes acceso a Internet e intenta nuevamente"
        
        let alerta = UIAlertController(title: "Pedido no enviado. ", message: mensaje, preferredStyle: .alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
            
            return
        }
        
        alerta.addAction(OKAction)
        present(alerta, animated: true, completion: { return })
        
        
        
    }

    


}
