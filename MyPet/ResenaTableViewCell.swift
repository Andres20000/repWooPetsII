//
//  ResenaTableViewCell.swift
//  MyPet
//
//  Created by Jose Aguilar on 3/08/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class ResenaTableViewCell: UITableViewCell
{
    @IBOutlet var imgEstrellaUno: UIImageView!
    @IBOutlet var imgEstrellaDos: UIImageView!
    @IBOutlet var imgEstrellaTres: UIImageView!
    @IBOutlet var imgEstrellaCuatro: UIImageView!
    @IBOutlet var imgEstrellaCinco: UIImageView!
    
    @IBOutlet var lblFecha: UILabel!
    @IBOutlet var lblUsuario: UILabel!
    @IBOutlet var textResena: UITextView!
    
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
