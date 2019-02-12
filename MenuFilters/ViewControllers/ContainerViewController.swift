//
//  ContainerViewController.swift
//  MenuFilters
//
//  Created by Lauren Nicole Roth on 2/12/19.
//  Copyright © 2019 Lauren Nicole Roth. All rights reserved.
//

import UIKit
import QuartzCore

class ContainerViewController: UIViewController {
  
  enum SlideOutState {
    case bothCollapsed
    case leftPanelExpanded
    case rightPanelExpanded
  }
  
  var browseNavigationController: UINavigationController!
  var browseViewController: BrowseViewController!
  
  var currentState: SlideOutState = .bothCollapsed {
    didSet {
      let shouldShowShadow = currentState != .bothCollapsed
      showShadowForBrowseViewController(shouldShowShadow)
    }
  }
  var leftViewController: SidePanelViewController?
  
  var rightViewController: SidePanelViewController?
  
  let browsePanelExpandedOffset: CGFloat = 200
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
    browseViewController = storyboard.instantiateViewController(withIdentifier: "BrowseViewController") as! BrowseViewController
    browseViewController.delegate = self
    
    browseNavigationController = UINavigationController(rootViewController: browseViewController)
    view.addSubview(browseNavigationController.view)
    addChild(browseNavigationController)
    
    browseNavigationController.didMove(toParent: self)
    
    let panGestureRecognizer = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
    browseNavigationController.view.addGestureRecognizer(panGestureRecognizer)
  }
}

// MARK: BrowseViewController delegate
extension ContainerViewController: BrowseViewControllerDelegate {
  
  func toggleLeftPanel() {
    
    let notAlreadyExpanded = (currentState != .leftPanelExpanded)
    
    if notAlreadyExpanded {
      addLeftPanelViewController()
    }
    
    animateLeftPanel(shouldExpand: notAlreadyExpanded)
  }
  
  func toggleRightPanel() {
    
    let notAlreadyExpanded = (currentState != .rightPanelExpanded)
    
    if notAlreadyExpanded {
      addRightPanelViewController()
    }
    
    animateRightPanel(shouldExpand: notAlreadyExpanded)
  }
  
  func collapseSidePanels() {
    
    switch currentState {
    case .rightPanelExpanded:
      toggleRightPanel()
    case .leftPanelExpanded:
      toggleLeftPanel()
    default:
      break
    }
  }
  
  func addLeftPanelViewController() {
    
    guard leftViewController == nil else { return }
    
    if let vc = UIStoryboard.leftViewController() {
      vc.menuItems = MenuItem.allMenuItems()
      addChildSidePanelController(vc)
      leftViewController = vc
    }
  }
  
  func addChildSidePanelController(_ sidePanelController: SidePanelViewController) {
    
    sidePanelController.delegate = browseViewController
    view.insertSubview(sidePanelController.view, at: 0)
    
    addChild(sidePanelController)
    sidePanelController.didMove(toParent: self)
  }
  
  func addRightPanelViewController() {
    
    guard rightViewController == nil else { return }
    
    if let vc = UIStoryboard.rightViewController() {
      vc.menuItems = MenuItem.allFilterItems()
      addChildSidePanelController(vc)
      rightViewController = vc
    }
  }
  
  func animateLeftPanel(shouldExpand: Bool) {
    
    if shouldExpand {
      currentState = .leftPanelExpanded
      animateBrowsePanelXPosition(targetPosition: browseNavigationController.view.frame.width - browsePanelExpandedOffset)
      
    } else {
      animateBrowsePanelXPosition(targetPosition: 0) { _ in
        self.currentState = .bothCollapsed
        self.leftViewController?.view.removeFromSuperview()
        self.leftViewController = nil
      }
    }
  }
  
  func animateBrowsePanelXPosition(targetPosition: CGFloat, completion: ((Bool) -> Void)? = nil) {
    
    UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
      self.browseNavigationController.view.frame.origin.x = targetPosition
    }, completion: completion)
  }
  
  func animateRightPanel(shouldExpand: Bool) {
    
    if shouldExpand {
      currentState = .rightPanelExpanded
      animateBrowsePanelXPosition(targetPosition: -browseNavigationController.view.frame.width + browsePanelExpandedOffset)
      
    } else {
      animateBrowsePanelXPosition(targetPosition: 0) { _ in
        self.currentState = .bothCollapsed
        self.rightViewController?.view.removeFromSuperview()
        self.rightViewController = nil
      }
    }
  }
  
  func showShadowForBrowseViewController(_ shouldShowShadow: Bool) {
    if shouldShowShadow {
      browseNavigationController.view.layer.shadowOpacity = 0.8
    } else {
      browseNavigationController.view.layer.shadowOpacity = 0.0
    }
  }
}

// MARK: Gesture recognizer

extension ContainerViewController: UIGestureRecognizerDelegate {
  
  @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
    
    let gestureIsDraggingFromLeftToRight = (recognizer.velocity(in: view).x > 0)
    
    switch recognizer.state {
      
    case .began:
      if currentState == .bothCollapsed {
        if gestureIsDraggingFromLeftToRight {
          addLeftPanelViewController()
        } else {
          addRightPanelViewController()
        }
        
        showShadowForBrowseViewController(true)
      }
      
    case .changed:
      if let rview = recognizer.view {
        rview.center.x = rview.center.x + recognizer.translation(in: view).x
        recognizer.setTranslation(CGPoint.zero, in: view)
      }
      
    case .ended:
      if let _ = leftViewController,
        let rview = recognizer.view {
        // animate the side panel open or closed based on whether the view has moved more or less than halfway
        let hasMovedGreaterThanHalfway = rview.center.x > view.bounds.size.width
        animateLeftPanel(shouldExpand: hasMovedGreaterThanHalfway)
        
      }
      if let _ = rightViewController,
        let rview = recognizer.view {
        let hasMovedGreaterThanHalfway = rview.center.x < 0
        animateRightPanel(shouldExpand: hasMovedGreaterThanHalfway)
      }
      
    default:
      break
    }
  }
}

private extension UIStoryboard {
  
  static func main() -> UIStoryboard { return UIStoryboard(name: "Main", bundle: Bundle.main) }
  
  static func leftViewController() -> SidePanelViewController? {
    return main().instantiateViewController(withIdentifier: "LeftViewController") as? SidePanelViewController
  }
  
  static func rightViewController() -> SidePanelViewController? {
    return main().instantiateViewController(withIdentifier: "RightViewController") as? SidePanelViewController
  }
  
  static func browseViewController() -> BrowseViewController? {
    return main().instantiateViewController(withIdentifier: "CenterViewController") as? BrowseViewController
  }
}

