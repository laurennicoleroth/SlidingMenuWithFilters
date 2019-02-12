//
//  SidePanelViewController.swift
//  MenuFilters
//
//  Created by Lauren Nicole Roth on 2/12/19.
//  Copyright © 2019 Lauren Nicole Roth. All rights reserved.
//

import UIKit

protocol SidePanelViewControllerDelegate {
  func didSelectMenuItem(_ menuItem: MenuItem)
}

class SidePanelViewController: UIViewController {
  
  @IBOutlet weak var tableView: UITableView!
  var delegate: SidePanelViewControllerDelegate?
  
  var menuItems: Array<MenuItem>!
  
  enum CellIdentifiers {
    static let MenuItemCell = "MenuItemCell"
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    tableView.reloadData()
  }
}

// MARK: Table View Data Source
extension SidePanelViewController: UITableViewDataSource {
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return menuItems.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: CellIdentifiers.MenuItemCell, for: indexPath) as! MenuItemCell
    cell.configureForMenuItem(menuItems[indexPath.row])
    return cell
  }
}

// Mark: Table View Delegate
extension SidePanelViewController: UITableViewDelegate {
  
  func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    let menuItem = menuItems[indexPath.row]
    delegate?.didSelectMenuItem(menuItem)
  }
}
