//
//  MenuItemCell.swift
//  MenuFilters
//
//  Created by Lauren Nicole Roth on 2/12/19.
//  Copyright © 2019 Lauren Nicole Roth. All rights reserved.
//

import UIKit

class MenuItemCell: UITableViewCell {
  @IBOutlet weak var menuItemImageView: UIImageView!
  @IBOutlet weak var menuNameLabel: UILabel!
  
  func configureForMenuItem(_ menuItem: MenuItem) {
    print("Configuring menuItem: ", menuItem.title)
    
    menuItemImageView.image = menuItem.image
    menuNameLabel.text = menuItem.title
  }
}
