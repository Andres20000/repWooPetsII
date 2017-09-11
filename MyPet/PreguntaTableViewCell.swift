//
//  PreguntaTableViewCell.swift
//  MyPet
//
//  Created by Jose Aguilar on 11/09/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class PreguntaTableViewCell: UITableViewCell
{
    @IBOutlet var lblFechaPregunta: UILabel!
    @IBOutlet var lblPreguntaUsuario: UILabel!
    
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
