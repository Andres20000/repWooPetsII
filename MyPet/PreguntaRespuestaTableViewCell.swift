//
//  PreguntaRespuestaTableViewCell.swift
//  MyPet
//
//  Created by Jose Aguilar on 3/08/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class PreguntaRespuestaTableViewCell: UITableViewCell
{
    @IBOutlet var lblFechaPregunta: UILabel!
    @IBOutlet var lblPreguntaUsuario: UILabel!
    @IBOutlet var lblFechaRespuesta: UILabel!
    @IBOutlet var lblEstadoPregunta: UILabel!
    @IBOutlet var textRespuestaOferente: UITextView!
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool)
    {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
