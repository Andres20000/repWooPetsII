//
//  TPaga.swift
//  Ensaladera
//
//  Created by Andres Garcia on 4/22/17.
//  Copyright © 2017 Tactoapps. All rights reserved.
//

import Foundation



class MiniTarjeta {
    
    var token = ""
    var numero = ""
    var cuotas = 1
    var activa = false
    var id = ""
    var pais = ""
    var inicialesPais = ""
    var franquicia = ""
    
    
}



class TPaga {
    
    
    
    let endPoint = "https://sandbox.tpaga.co/api/"

    let privateKey = "mchv8e16el0evvnq0at5fmgb1p7e8jhu:"
    
    let publicKey = "4p0b25t9rjfb5jl5cv0l7lda2gf3nm3c:"

    var noDeseaIncribirTarjeta = false
    
    var miniTarjetas:[MiniTarjeta] = []
    
    var idClienteEnTpaga = ""
    
    var vistaInicioCreacionTarjeta = ""
    
    var authorizationCode  = ""    // temporal para guardar ultima transaccion
    var paymentTransaction = ""    // temporal para guardar ultima transaccion
    var idPago = ""
    
    
    var nombre = ""
    var apellido = ""
    var telefono = ""
    var correo = ""
    
    
    init() {
        
    }
    
    
    func getTarjetaActiva() -> MiniTarjeta? {
        
        for tarjeta in miniTarjetas {
            if tarjeta.activa == true {
                return tarjeta
            }
            
        }
        return nil
    }
    
    
    func adicionarMiniTarjeta(mini:MiniTarjeta) {
        
        var index = 0
        for tarjeta in miniTarjetas {
            if tarjeta.token == mini.token {
                miniTarjetas.remove(at: index)
            }
         
            index += 1
            
        }
        miniTarjetas.append(mini)
        
        NotificationCenter.default.post(name: Notification.Name(rawValue: "adicionoTarjeta"), object: nil)
        
    }
    
    func desactivarTodasTarjetas(uid:String) {
     
        for tarjeta in miniTarjetas {
           
            tarjeta.activa = false
            ComandoOferente.desactivarTarjeta(uid: uid, idTarjeta: tarjeta.id)
            
        }
        
    }
    
    func matchesRegex(regex: String!, text: String!) -> Bool {
        do {
            let regex = try NSRegularExpression(pattern: regex, options: [.caseInsensitive])
            let nsString = text as NSString
            let match = regex.firstMatch(in: text, options: [], range: NSMakeRange(0, nsString.length))
            return (match != nil)
        } catch {
            return false
        }
    }
    
    
    func getCreditCardType(numberOnly:String) -> CardType {
        
        for card in CardType.allCards {
            if (matchesRegex(regex: card.regex, text: numberOnly)) {
                return card
            }
        }
        
        return .Unknown
    }
    
    func clear() {
        
        noDeseaIncribirTarjeta = false
    
        miniTarjetas.removeAll()
        
        idClienteEnTpaga = ""
        
        vistaInicioCreacionTarjeta = ""
        
        
        
    }

    
    
      
}



enum CardType: String {
    case Unknown, Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay
    
    static let allCards = [Amex, Visa, MasterCard, Diners, Discover, JCB, Elo, Hipercard, UnionPay]
    
    var regex : String {
        switch self {
        case .Amex:
            return "^3[47][0-9]{5,}$"
        case .Visa:
            return "^4[0-9]{6,}([0-9]{3})?$"
        case .MasterCard:
            return "^(5[1-5][0-9]{4}|677189)[0-9]{5,}$"
        case .Diners:
            return "^3(?:0[0-5]|[68][0-9])[0-9]{4,}$"
        case .Discover:
            return "^6(?:011|5[0-9]{2})[0-9]{3,}$"
        case .JCB:
            return "^(?:2131|1800|35[0-9]{3})[0-9]{3,}$"
        case .UnionPay:
            return "^(62|88)[0-9]{5,}$"
        case .Hipercard:
            return "^(606282|3841)[0-9]{5,}$"
        case .Elo:
            return "^((((636368)|(438935)|(504175)|(451416)|(636297))[0-9]{0,10})|((5067)|(4576)|(4011))[0-9]{0,12})$"
        default:
            return ""
        }
    }
}





