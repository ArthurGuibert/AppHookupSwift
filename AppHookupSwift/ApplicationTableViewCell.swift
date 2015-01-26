//
//  ApplicationTableViewCell.swift
//  AppHookupSwift
//
//  Created by Arthur GUIBERT on 25/01/2015.
//  Copyright (c) 2015 Arthur GUIBERT. All rights reserved.
//

import UIKit

class ApplicationTableViewCell: UITableViewCell {
    @IBOutlet weak var appName: UILabel!
    @IBOutlet weak var appIcon: UIImageView!
    @IBOutlet weak var appPublisher: UILabel!
    @IBOutlet weak var appPrice: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Set a custom border
        let border = CALayer()
        border.frame = CGRectMake(32, self.frame.height - 0.5, UIScreen.mainScreen().bounds.size.width - 64, 0.5)
        border.backgroundColor = UIColor(white: 0.9, alpha: 1).CGColor
        border.zPosition = 10
        self.layer.addSublayer(border)
        
        // Set the corner so that the icon is a circle, wow, such a nice effect.
        self.appIcon.layer.cornerRadius = self.appIcon.frame.size.width / 2
        self.appIcon.layer.masksToBounds = true
    }
    
}
