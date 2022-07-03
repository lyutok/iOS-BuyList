//
//  ListCell.swift
//  BuyList
//
//  Created by Lyudmila Tokar on 4/16/21.
//

import UIKit

class ListCell: UITableViewCell {
    
    
    @IBOutlet weak var listView: UIView!
    @IBOutlet weak var bulletPoint: UILabel!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var checkMark: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        listView.layer.cornerRadius = listView.frame.height / 5
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
}
