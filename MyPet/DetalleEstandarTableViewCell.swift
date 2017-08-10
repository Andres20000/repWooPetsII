//
//  DetalleEstandarTableViewCell.swift
//  MyPet
//
//  Created by Jose Aguilar on 22/05/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class DetalleEstandarTableViewCell: UITableViewCell
{
    @IBOutlet var lblTitulo: UILabel!
    @IBOutlet var lblDescripcion: UILabel!
    @IBOutlet var viewDetalleEstandarBottom: UIView!

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
