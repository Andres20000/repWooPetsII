//
//  ChatCeldaSinRespuesta.swift
//  MyPet
//
//  Created by Andres Garcia on 8/14/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class ChatCeldaSinRespuesta: UITableViewCell {
    
    
    @IBOutlet weak var hora: UILabel!
    @IBOutlet weak var pregunta: UILabel!

    @IBOutlet weak var viewResponder: UIView!
    
    @IBOutlet weak var boton: UIButton!
    
        
    var seccion = -1;
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
