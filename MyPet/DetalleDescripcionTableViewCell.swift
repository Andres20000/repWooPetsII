//
//  DetalleDescripcionTableViewCell.swift
//  MyPet
//
//  Created by Jose Aguilar on 22/05/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class DetalleDescripcionTableViewCell: UITableViewCell
{
    
    @IBOutlet var lblTitulo: UILabel!
    @IBOutlet var textDescripcion: UITextView!
    
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
