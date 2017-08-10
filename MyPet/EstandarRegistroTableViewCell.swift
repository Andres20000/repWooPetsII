//
//  EstandarRegistroTableViewCell.swift
//  MyPet
//
//  Created by Jose Aguilar on 27/04/17.
//  Copyright © 2017 Jose Aguilar. All rights reserved.
//

import UIKit

class EstandarRegistroTableViewCell: UITableViewCell
{
    @IBOutlet var txtCampo: UITextField!
    @IBOutlet var lblNombreCampo: UILabel!
    @IBOutlet var imgFlecha: UIImageView!
    
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
