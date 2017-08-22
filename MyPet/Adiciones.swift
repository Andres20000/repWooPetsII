//
//  Adiones.swift
//  Ensaladera
//
//  Created by Andres Garcia on 9/24/16.
//  Copyright © 2016 Tactoapps. All rights reserved.
//

import Foundation
import UIKit





extension UIImageView {
    
    func sendToFire(){
        
    }
    
}


public extension Data {
    var tipoImagen: String {
        var values = [UInt8](repeating:0, count:1)
        self.copyBytes(to: &values, count: 1)
        
        let ext: String
        switch (values[0]) {
        case 0xFF:
            ext = ".jpeg"
        case 0x89:
            ext = ".png"
        case 0x47:
            ext = ".gif"
        case 0x49, 0x4D :
            ext = ".tiff"
        default:
            ext = ".png"
        }
        return ext
    }
}


extension Date {
    
    
    func horaActual() -> String {
        
        let newfecha  = Date()
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "h:mm a"
        
        let dateString = dateFormatter.string(from: newfecha)
        return dateString
        
    }
    
    
    func fechaString() -> String {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        let dateString = dateFormatter.string(from: self)
        return dateString
        
    }
    
    func fechaStringLarga() -> String {
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .full
        
        let dateString = dateFormatter.string(from: self)
        return dateString
        
    }
    
    
    
    func fechaParaPintar() -> String {
        if esHoy() {
            return "Hoy"
        }
        if esManana() {
            return "Mañana"
        }
        if esPasadoManana() {
            return "Pasado Mañana"
        }
        return fechaString()
        
    }
    
    func fechaParaPintarHistoricoTerrenal() -> String {
        if esHoy() {
            return "Hoy"
        }
        
        if fueAyer() {
            return "Ayer"
        }
        if esManana() {
            return "Mañana"
        }
        if esPasadoManana() {
            return "Pasado Mañana"
        }
        return fechaStringLarga()
        
    }
    
    
    
    
    func fechaParaPintarDeCamion() -> String {
        
        if esHoy() {
            return "Hoy"
        }
        if esManana() {
            return "Mañana"
        }
        if esPasadoManana() {
            return "Pasado Mañana"
        }
        
        if self.esMenorQueFecha(Date()){
            return "Hoy"
        }
        
        return fechaString()
        
    }
    
    
    
    func fechaMediumPintar() -> String {
        if esHoy() {
            return "Hoy"
        }
        if esManana() {
            return "Mañana"
        }
        if esPasadoManana() {
            return "Pasado Mañana"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat  =  "EEEE, MMMM dd"
        
        let dateString = dateFormatter.string(from: self)
        return dateString
        
        
    }
    
    
    func localTimeCantidad() -> Int {
        return abs(NSTimeZone.local.secondsFromGMT())
        
    }
    
    
    func diasHasta(_ otraDate:Date) -> Int{
        let cal = Calendar.current
        
        
        let unit:NSCalendar.Unit = .day
        
        let components = (cal as NSCalendar).components(unit, from: otraDate, to: self, options: [])
        
        return components.day!
        
        
    }
    
    func fueAyer() -> Bool{
        
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let  newDate = cal.startOfDay(for: Date())
        
        if diasHasta(newDate) == -1 {
            return true
        }
        return false
        
    }
    
    func esHoy() -> Bool {
        
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let  newDate = cal.startOfDay(for: Date())
        
        if diasHasta(newDate) == 0 {
            return true
        }
        return false
    }
    
    func esManana() -> Bool {
        
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let  newDate = cal.startOfDay(for: Date())
        
        
        if diasHasta(newDate) == 1 {
            return true
        }
        return false    }
    
    
    func esPasadoManana() -> Bool {
        
        
        
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let  newDate = cal.startOfDay(for: Date())
        
        
        if diasHasta(newDate) == 2 {
            return true
        }
        return false
    }
    
    func addDays(_ additionalDays: Int) -> Date {
        // adding $additionalDays
        var components = DateComponents()
        components.day = additionalDays
        
        // important: NSCalendarOptions(0)
        let futureDate = (Calendar.current as NSCalendar)
            .date(byAdding: components, to: self, options: NSCalendar.Options(rawValue: 0))
        return futureDate!
    }
    
    
    
    /// Pilas que estas entan comparando dias completos , no tiene encuenta horas ni minutos
    func esMayorQueFecha(_ dateToCompare: Date) -> Bool {
        
        if self.esMismoDia(dateToCompare) {
            return false
        }
        var isGreater = false
        
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        return isGreater
    }
    
    /// Pilas que estas entan comparando dias completos , no tiene encuenta horas ni minutos
    func esMenorQueFecha(_ dateToCompare: Date) -> Bool {
        
        if self.esMismoDia(dateToCompare) {
            return false
        }
        
        
        var isLess = false
        
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        return isLess
    }
    
    
    
    /// Pilas que estas entan comparando dias completos , no tiene encuenta horas ni minutos
    func esMismoDia(_ date: Date?) -> Bool {
        if let d = date {
            let calendar = Calendar.current
            if ComparisonResult.orderedSame == (calendar as NSCalendar).compare(self, to: d, toUnitGranularity: .day) {
                return true
            }
            
        }
        return false
    }
    
    
    func getDayOfWeek() -> Int? {
        var myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: self)
        return weekDay
    }
    
    
    
    func getHoraDeHoy(hora:Int) -> Date {
        //var components  = DateComponents()
        //let units : NSCalendar.Unit = [.hour, .day, .year]
        let calendar = Calendar.current
        
        var apertura = DateComponents()
        apertura.year = calendar.component(.year, from: self)
        apertura.month = calendar.component(.month, from: self)
        apertura.day = calendar.component(.day, from: self)
        apertura.hour = hora
        
        return calendar.date(from: apertura)!
        
    }
    
    
    
    func esMayorQueFechaCompleta(_ dateToCompare: Date) -> Bool {
        
        var isGreater = false
        
        if self.compare(dateToCompare) == ComparisonResult.orderedDescending {
            isGreater = true
        }
        return isGreater
    }
    
    
    func esMenorQueFechaCompleta(_ dateToCompare: Date) -> Bool {
        
        var isLess = false
        
        if self.compare(dateToCompare) == ComparisonResult.orderedAscending {
            isLess = true
        }
        
        return isLess
    }
    
    
    
    
}











extension Dictionary {
    
    
    func jsonData() -> Data? {
        
        do {
            let json:Data = try JSONSerialization.data(withJSONObject: self, options: JSONSerialization.WritingOptions.prettyPrinted)
            return json
            
        } catch {
            print("No pudo convertir a json: \(self)")
            return nil
            
        }
        
        
    }
}



extension String {
    
    
    func quitarEspacios() -> String{
        
        let res = self.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
        return res
        
    }
    
    func quitarEspaciosYTildes() -> String{
        
        var res = self.replacingOccurrences(of: " ", with: "", options: NSString.CompareOptions.literal, range: nil)
        res = res.replacingOccurrences(of: "á", with: "a", options: NSString.CompareOptions.literal, range: nil)
        res = res.replacingOccurrences(of: "í", with: "i", options: NSString.CompareOptions.literal, range: nil)
        res = res.replacingOccurrences(of: "ó", with: "o", options: NSString.CompareOptions.literal, range: nil)
        res = res.replacingOccurrences(of: "é", with: "e", options: NSString.CompareOptions.literal, range: nil)
        res = res.replacingOccurrences(of: "ú", with: "u", options: NSString.CompareOptions.literal, range: nil)
        res = res.replacingOccurrences(of: "ñ", with: "n", options: NSString.CompareOptions.literal, range: nil)
        
        return res
        
    }
    
    
    func convertToFecha() -> Date {
        
        if self == "" {
            let cal = Calendar(identifier: Calendar.Identifier.gregorian)
            let newDate = cal.startOfDay(for: Date())
            
            return newDate
            
        }
        
        if self == "Hoy" {
            let cal = Calendar(identifier: Calendar.Identifier.gregorian)
            let newDate = cal.startOfDay(for: Date())
            
            return newDate
        }
        
        if self == "Mañana" {
            let cal = Calendar(identifier: Calendar.Identifier.gregorian)
            let newDate = cal.startOfDay(for: Date().addDays(1))
            
            return newDate
        }
        
        if self == "Pasado Mañana" {
            let cal = Calendar(identifier: Calendar.Identifier.gregorian)
            let newDate = cal.startOfDay(for: Date().addDays(2))
            return newDate
            
        }
        
        let dateFormatter = DateFormatter()
        if self.characters.count > 11 {
            dateFormatter.dateFormat = "YYYY-MM-DD HH:mm:ss ZZZ"
        }
        else {
            dateFormatter.dateFormat = "dd/MM/yyyy"
        }
        
        var date = dateFormatter.date(from: self)
        
        if date == nil {
            dateFormatter.dateFormat = "EEEE, MMMM dd"
            date = dateFormatter.date(from: self)
        }
        
        
        let cal = Calendar(identifier: Calendar.Identifier.gregorian)
        let newDate = cal.startOfDay(for: date!)
        
        return newDate
        
        
    }
    
    
    
    
    func isValidEmail() -> Bool {
        
        let placaRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,6}"
        
        
        let placaTest = NSPredicate(format:"SELF MATCHES %@", placaRegEx)
        return placaTest.evaluate(with: self)
    }
    
    
    func isValidPlaca(_ testStr:String) -> Bool {
        // println("validate calendar: \(testStr)")
        let placaRegEx = "^[A-Z]{3}\\d{3}"
        
        let placaTest = NSPredicate(format:"SELF MATCHES %@", placaRegEx)
        return placaTest.evaluate(with: testStr)
    }
    
    
    func convertToMoney() -> String {
        
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        
        formatter.locale = Locale(identifier: "es_CL")
        
        let valor:NSNumber = NSNumber(value: Float(self)!)
        return formatter.string(from: valor)!
        
    }
    
    
    func fromBase64() -> String? {
        guard let data = Data(base64Encoded: self) else {
            return nil
        }
        
        return String(data: data, encoding: .utf8)
        
    }
    
    
    func toBase64() -> String {
        return Data(self.utf8).base64EncodedString()
        
    }
    
    
    
}


