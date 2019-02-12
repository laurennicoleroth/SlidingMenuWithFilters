//
//  MenuItem.swift
//  MenuFilters
//
//  Created by Lauren Nicole Roth on 2/12/19.
//  Copyright © 2019 Lauren Nicole Roth. All rights reserved.
//

import UIKit

struct MenuItem {
  let title: String
  let image: UIImage?
  
  init(title: String, image: UIImage?) {
    self.title = title
    self.image = image
  }
  
  static func allMenuItems() -> [MenuItem] {
    return [
      MenuItem(title: "Profile", image: UIImage(named: "profile") ?? UIImage()),
      MenuItem(title: "Settings", image: UIImage(named: "settings") ?? UIImage()),
      MenuItem(title: "Notifications", image: UIImage(named: "clock") ?? UIImage()),
      MenuItem(title: "Logout", image: UIImage(named: "profile") ?? UIImage())
    ]
  }
  
  static func allFilterItems() -> [MenuItem] {
    return [
      MenuItem(title: "Nearby", image: UIImage(named: "compass") ?? UIImage()),
      MenuItem(title: "Popular", image: UIImage(named: "profile") ?? UIImage()),
      MenuItem(title: "Top Rated", image: UIImage(named: "star") ?? UIImage()),
      MenuItem(title: "Recent", image: UIImage(named: "clock") ?? UIImage())
    ]
  }
}
