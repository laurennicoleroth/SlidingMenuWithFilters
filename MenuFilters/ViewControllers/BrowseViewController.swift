//
//  BrowseViewController.swift
//  MenuFilters
//
//  Created by Lauren Nicole Roth on 2/12/19.
//  Copyright © 2019 Lauren Nicole Roth. All rights reserved.
//

import UIKit

@objc
protocol BrowseViewControllerDelegate {
  @objc optional func toggleLeftPanel()
  @objc optional func toggleRightPanel()
  @objc optional func collapseSidePanels()
}

class BrowseViewController: UIViewController {
  
  var delegate: BrowseViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()

  }
  
  // MARK: Button actions
  @IBAction func menuItemTapped(_ sender: Any) {
    delegate?.toggleLeftPanel?()
  }
  
  @IBAction func filterItemTapped(_ sender: Any) {
    delegate?.toggleRightPanel?()
  }
  
}

extension BrowseViewController: SidePanelViewControllerDelegate {
  func didSelectMenuItem(_ menuItem: MenuItem) {
    print("Selected: ", menuItem.title)
    
    delegate?.collapseSidePanels?()
  }
}
