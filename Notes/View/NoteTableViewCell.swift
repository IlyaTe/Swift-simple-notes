//
//  NoteTableViewCell.swift
//  Notes
//
//  Created by Илья on 08.02.2020.
//  Copyright © 2020 Ilya. All rights reserved.
//

import UIKit

class NoteTableViewCell: UITableViewCell {

    @IBOutlet weak var textNode: UILabel?
    @IBOutlet weak var date: UILabel?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
