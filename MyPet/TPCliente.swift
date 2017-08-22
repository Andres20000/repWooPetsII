//
//  TPCliente.swift
//  TPagaTest
//
//  Created by Andres Garcia on 3/7/17.
//  Copyright © 2017 Tactoapps. All rights reserved.
//

import Foundation


let endPoint = "https://sandbox.tpaga.co/api/"
let privateKey = "mchv8e16el0evvnq0at5fmgb1p7e8jhu:"
let publicKey = "4p0b25t9rjfb5jl5cv0l7lda2gf3nm3c:"

var privateKeyEnc:String {
    return privateKey.toBase64()
}

var publicKeyEnc:String {
    return publicKey.toBase64()
}

let defaultSession = URLSession(configuration: URLSessionConfiguration.ephemeral)


struct TPCliente {
    
    var merchantCustomerId:String = ""
    var phone:String = ""
    var legalIdNumber: String = ""          // Cedula
    var email:String = ""
    var lastName:String = ""
    var firstName:String = ""
    var ciudad:String = ""
    var inicialesPais:String = ""
    var direccion : String = ""
    var telefono : String = ""

}

struct TPTarjeta {
    
    var cardHolderName:String = ""
    var primaryAccountNumber:String = ""
    var expirationYear: String = ""          // ej: 2020
    var expirationMonth:String = ""
    var cvc:String = ""
    
}

struct TPPago {
    var description: String = ""
    var creditCard: String = ""
    var amount: Int = 0
    var taxAmount:Int = 0
    var installments = 1
    var orderId = ""
    var currency = "COP"
    
    
}




enum SerializacionError: Error {
    case missing(String)
    case invalid(String, Any)
}





extension TPTarjeta  {
    
    init(json:[String:Any]) throws {
        
        guard let cardHolderName = json["cardHolderName"] as? String  else {
            throw SerializacionError.missing("cardHolderName")
        }
        
        guard let primaryAccountNumber = json["primaryAccountNumber"]  as? String else {
            throw SerializacionError.missing("primaryAccountNumber")
        }
        
        guard let expirationYear = json["expirationYear"] as? String else {
            throw SerializacionError.missing("expirationYear")
        }
        
        guard let expirationMonth = json["expirationMonth"] as? String else  {
            throw SerializacionError.missing("expirationMonth")
        }
        
        guard let cvc = json["cvc"] as? String else {
            throw SerializacionError.missing("cvc")
        }
        
        
        self.cardHolderName = cardHolderName
        self.primaryAccountNumber = primaryAccountNumber
        self.expirationYear = expirationYear
        self.expirationMonth = expirationMonth
        self.cvc = cvc
        
    }
    
    
    
    
    static func crearTarjetaEnTpaga(tarjeta:TPTarjeta, completion: @escaping (_ token:String?, Error?) -> Void) {
        
        
        let url = NSURL(string: endPoint + "tokenize/credit_card")
        
        var request = URLRequest(url: url! as URL)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        request.addValue("Basic " + publicKeyEnc, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"

        
        let tarj: Data = convertTarjeta(tarjeta: tarjeta)
        
        let dataTask = defaultSession.uploadTask(with: request, from: tarj, completionHandler: {(data,response,error) in
            
            
            if error != nil {
                completion(nil, error)
                return
                
            }
            
            print(error?.localizedDescription ?? 0)
            
            let httpResponse = response as! HTTPURLResponse
            
            switch httpResponse.statusCode {
            case 201 :
                if let data = data,
                    //let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? NSDictionary {
                    print(json ?? 0)
                    do {
                        guard let token = json!["token"]  as? String else {
                            completion(nil, SerializacionError.missing("token"))
                            return
                        }
                        
                        completion(token, error)
                        return
                    }
                    
                }
                
            case 400 :
                completion(nil, TPagaError.noJson)
                return
            case 401 :
                completion(nil, TPagaError.noAutorizado)
                return
            case 422 :
                
                
                if let json = try? JSONSerialization.jsonObject(with: data!, options: []) as? NSDictionary {
                    print(json)
                }
                print(response)
                print(error)

                completion(nil, TPagaError.camposErroneos)
                return
                
            default:
                print(response!)
                //completion(nil, TPagaError.desconocido)
                
            }
            
            print(data)
            print(response)
            print(error)
            
            
        });
        
        dataTask.resume()
        
    }
    
    
    fileprivate static func convertTarjeta(tarjeta:TPTarjeta) -> Data {
        
        let dicc = ["cardHolderName":tarjeta.cardHolderName,
                    "primaryAccountNumber":tarjeta.primaryAccountNumber,
                    "expirationYear":tarjeta.expirationYear,
                    "expirationMonth":tarjeta.expirationMonth,
                    "cvc":tarjeta.cvc]
        
        
        let jsonData: NSData = try! JSONSerialization.data(withJSONObject: dicc, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
        
        
        //let str = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
        //print(str)
        
        return jsonData as Data
        
        
    }
    

    
}



extension TPPago {
    
    

    
    init(json:[String:Any]) throws {
        
        guard let description = json["description"] as? String  else {
            throw SerializacionError.missing("description")
        }
        
        guard let creditCard = json["creditCard"]  as? String else {
            throw SerializacionError.missing("creditCard")
        }
        
        guard let amount = json["amount"] as? Int else {
            throw SerializacionError.missing("amount")
        }
        
        guard let taxAmount = json["taxAmount"] as? Int else  {
            throw SerializacionError.missing("taxAmount")
        }
        
        guard let installments = json["installments"] as? Int else {
            throw SerializacionError.missing("installments")
        }
        
        guard let orderId = json["orderId"] as? String else {
            throw SerializacionError.missing("orderId")
        }
        
        guard let currency = json["currency"] as? String else {
            throw SerializacionError.missing("currency")
        }
        
        
        self.description = description
        self.creditCard = creditCard
        self.amount = amount
        self.taxAmount = taxAmount
        self.installments = installments
        self.orderId = orderId
        self.currency = currency
        
        
    }

    
    
    
    
    
}


extension TPCliente {
    
    
    init(json:[String:Any]) throws {
        
        guard let merchantCustomerId = json["merchantCustomerId"] as? String  else {
            throw SerializacionError.missing("merchantCustomerId")
        }
        
        guard let phone = json["phone"]  as? String else {
            throw SerializacionError.missing("phone")
        }
        
        guard let legalIdNumber = json["legalIdNumber"] as? String else {
            throw SerializacionError.missing("legalIdNumber")
        }
        
        guard let email = json["email"] as? String else  {
            throw SerializacionError.missing("email")
        }
        
        guard let lastName = json["lastName"] as? String else {
            throw SerializacionError.missing("lastName")
        }
        
        guard let firstName = json["firstName"] as? String else {
            throw SerializacionError.missing("firstName")
        }
        
        guard let telefono = json["firstName"] as? String else {
            throw SerializacionError.missing("phone")
        }
        
        self.merchantCustomerId = merchantCustomerId
        self.phone = phone
        self.legalIdNumber = legalIdNumber
        self.email = email
        self.lastName = lastName
        self.firstName = firstName
        self.telefono = telefono
        
    }
    
    
    
    
    static func getCliente(idTPaga:String, completion: @escaping (TPCliente?, Error?) -> Void) {
        
        
        let url = NSURL(string: endPoint + "customer/" + idTPaga)
        
        var request = URLRequest(url: url! as URL)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        request.addValue("Basic " + privateKeyEnc, forHTTPHeaderField: "Authorization")
        request.httpMethod = "GET"
        
        let dataTask = defaultSession.dataTask(with: request, completionHandler: {(data,response,error) in 
            
            
            if error != nil {
               completion(nil, error)
               return
               
            }
            
            let httpResponse = response as! HTTPURLResponse
            
            switch httpResponse.statusCode {
                case 200 :
                    if let data = data,
                        let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        
                        do {
                            let cliente = try TPCliente(json: json!)
                            completion(cliente, error)
                            return
                        }
                        catch let error as NSError {
                            completion(nil, error)
                            return
                        }
                        
                     }
                
                case 404 :
                    completion(nil, TPagaError.idClienteNoExiste)
                    return
                case 401 :
                    completion(nil, TPagaError.noAutorizado)
                    return
                
                default:
                    print(response!)
                    completion(nil, TPagaError.desconocido)
                
            }
            
            print(data)
            print(response)
            print(error)
            

        });
        
        dataTask.resume()
        
    }
    
    


    
    static func crearClienteEnTpaga(cliente:TPCliente, completion: @escaping (_ idClienteTpaga:String?, Error?) -> Void) {
        
        
        let url = NSURL(string: endPoint + "customer")
        
        var request = URLRequest(url: url! as URL)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        request.addValue("Basic " + privateKeyEnc, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let cli: Data = convertCliente(cliente: cliente)
        
        let dataTask = defaultSession.uploadTask(with: request, from: cli, completionHandler: {(data,response,error) in
            
            
            if error != nil {
                completion(nil, error)
                return
                
            }
            
            let httpResponse = response as! HTTPURLResponse
            
            switch httpResponse.statusCode {
            case 201 :
                if let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    
                    do {
                        guard let id = json!["id"]  as? String else {
                            completion(nil, SerializacionError.missing("id"))
                            return
                        }
                        
                        completion(id, error)
                        return
                    }
                    
                    
                }
                
            case 400 :
                completion(nil, TPagaError.noJson)
                return
            case 401 :
                completion(nil, TPagaError.noAutorizado)
                return
            case 422 :
                if let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    print(json)
                }
                
            
                completion(nil, TPagaError.camposErroneos)
                return
                
            default:
                print(response!)
                completion(nil, TPagaError.desconocido)
                
            }

 
            
            print(data)
            print(response)
            print(error)
            
            
        });
        
        dataTask.resume()
        
    }
    
    
    
    static func asociarTarjeta2Cliente(idCliente:String, token:String, completion: @escaping ( _ token:String?, _ lastFour:String?, Error?) -> Void) {
        
        
        let url = NSURL(string: endPoint + "customer" + "/" + idCliente + "/credit_card_token")
        
        var request = URLRequest(url: url! as URL)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")  // the request is JSON
        request.addValue("Basic " + privateKeyEnc, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let tok: Data = convertToken(token: token)
        
        let dataTask = defaultSession.uploadTask(with: request, from: tok, completionHandler: {(data,response,error) in
            
            
            if error != nil {
                completion(nil,nil, error)
                return
                
            }
            
            let httpResponse = response as! HTTPURLResponse
            
            switch httpResponse.statusCode {
            case 201 :
                if let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    do {
                        guard let id = json!["id"]  as? String else {
                            completion(nil, nil, SerializacionError.missing("id"))
                            return
                        }
                        guard let lastFour = json!["lastFour"]  as? String else {
                            completion(nil, nil, SerializacionError.missing("lastFour"))
                            return
                        }
                        
                        completion(id, lastFour, error)
                        return
                    }
                    
                }
                
            case 400 :
                completion(nil, nil, TPagaError.noJson)
                return
            case 401 :
                completion( nil, nil,  TPagaError.noAutorizado)
                return
            case 422 :
                completion( nil, nil, TPagaError.camposErroneos)
                return
                
            default:
                print(response!)
                completion( nil,nil , TPagaError.desconocido)
                
            }
            
            
            print(data ?? "Pailas")
            print(response)
            print(error)
            
            
        });
        
        dataTask.resume()
        
    }
    
    
    
    static func hacerPago(pago:TPPago, completion: @escaping ( _ autorizado:Bool?, _ autorizacionCode:String? , _ paymentTransaction:String?, _ idPago:String?, Error?) -> Void) {
        
        
        let url = NSURL(string: endPoint + "charge/credit_card")
        
        var request = URLRequest(url: url! as URL)
        request.setValue("application/json; charset=utf-8", forHTTPHeaderField: "Content-Type")
        request.addValue("Basic " + privateKeyEnc, forHTTPHeaderField: "Authorization")
        request.httpMethod = "POST"
        
        let tok: Data = convertPago(pago: pago)
        
        let dataTask = defaultSession.uploadTask(with: request, from: tok, completionHandler: {(data,response,error) in
            
            
            if error != nil {
                completion(nil,nil, nil, nil, error)
                return
                
            }
            
            let httpResponse = response as! HTTPURLResponse
            
            switch httpResponse.statusCode {
            case 201 :
                if let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    do {
                        guard let paymentTransaction = json!["paymentTransaction"]  as? String else {
                            completion(nil, nil, nil, nil, SerializacionError.missing("paymentTransaction"))
                            return
                        }
                        guard let transac = json!["transactionInfo"]  as? [String:Any] else {
                            completion(nil, nil, nil, nil, SerializacionError.missing("transactionInfo"))
                            return
                        }
                        
                        guard let authorizationCode = transac["authorizationCode"]  as? String else {
                            completion(nil, nil, nil, nil, SerializacionError.missing("authorizationCode"))
                            return
                        }
                        
                        guard let idPago = json!["id"]  as? String else {
                            completion(nil, nil, nil, nil, SerializacionError.missing("id"))
                            return
                        }
                        
                        guard let status = transac["status"]  as? String else {
                            completion(nil, nil, nil, nil, SerializacionError.missing("status"))
                            return
                        }
                        
                        if status != "authorized" {
                            completion(false, nil, nil, nil, error)
                            return
                        }
                        
                        
                        completion(true, authorizationCode, paymentTransaction, idPago, error)
                        
                        return
                    }
            
                    
                }
                
            case 400 :
                completion(nil,nil,nil, nil,  TPagaError.noJson)
                return
            case 401 :
                completion( nil,nil,nil, nil, TPagaError.noAutorizado)
                return
            case 402 :
                 if let data = data,
                    let json = try? JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                    do {
                        guard let mensajeRechazo = json!["errorMessage"]  as? String else {
                            completion(nil, nil, nil, nil, TPagaError.desconocido)
                            return
                        }
                        
                        completion( nil,nil,nil, nil, TPagaError.rechazada(mensajeRechazo))
                        return
                    }
                }
            case 422 :
                let json = try! JSONSerialization.jsonObject(with: data!, options: []) as? [String: Any]
                print(json)
                completion( nil,nil,nil, nil, TPagaError.camposErroneos)
                return
                
            default:
                print(response!)
                completion( nil,nil,nil, nil, TPagaError.desconocido)
                
            }
            
            
            
            print(data ?? "Pailas")
            print(response)
            print(error)
            
            
        });
        
        dataTask.resume()
        
    }

    


    
     fileprivate static func convertCliente(cliente:TPCliente) -> Data {
        
         /* let direccion = ["addressLine1":cliente.direccion,
                         "addressLine2":"",
                         "postalCode":"0",
                         "city":["state":"DC","name":cliente.ciudad, "country":cliente.inicialesPais]] as [String : Any]*/
        

        
        
        let dicc = ["merchantCustomerId":cliente.merchantCustomerId,
                    "phone":cliente.phone,
                    "lastName":cliente.lastName,
                    "email":cliente.email,
                    "firstName":cliente.firstName] as [String : Any]
        
        
        
        let jsonData: NSData = try! JSONSerialization.data(withJSONObject: dicc, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
        
        
        let str = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
        print(str)
    
        return jsonData as Data
        
        
    }
    
    fileprivate static func convertPago(pago:TPPago) -> Data {
        
        
        
        let dicc = ["description":pago.description,
                    "creditCard":pago.creditCard,
                    "amount":pago.amount,
                    "taxAmount":0,
                    "iacAmount" :Int( Double(pago.amount) * 0.08),
                    "installments":pago.installments,
                    "orderId":pago.orderId,
                    "currency":pago.currency] as [String : Any]
        
        
        let jsonData: NSData = try! JSONSerialization.data(withJSONObject: dicc, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
        
        
        //let str = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
        //print(str)
        
        return jsonData as Data
        
        
    }
    
    
    
    
    fileprivate static func convertToken(token:String) -> Data {
        
        let dicc = ["token": token]
        
        
        let jsonData: NSData = try! JSONSerialization.data(withJSONObject: dicc, options: JSONSerialization.WritingOptions.prettyPrinted) as NSData
        
        
        //let str = NSString(data: jsonData as Data, encoding: String.Encoding.utf8.rawValue)! as String
        //print(str)
        
        return jsonData as Data
        
        
    }
   
    
}
