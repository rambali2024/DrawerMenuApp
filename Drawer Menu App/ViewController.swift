//
//  ViewController.swift
//  Drawer Menu App
//
//  Created by Ram on 26.09.2020.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var navigationBar: UINavigationBar!
    @IBOutlet weak var containerView: UIView!

    var currentController: UIViewController?
    let slideAnimation = DrawerSlideAnimation()
    var SAdirection = SlideAnimationDirection()

    override func viewDidLoad() {
        super.viewDidLoad()
        setCurrentView(for: .home)
        let swipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        swipeGesture.direction = .right
        view.addGestureRecognizer(swipeGesture)
        
        let rightSwipeGesture = UISwipeGestureRecognizer(target: self, action: #selector(handleSwipe(sender:)))
        rightSwipeGesture.direction = .left
        view.addGestureRecognizer(rightSwipeGesture)
    }
    
    @objc  func handleSwipe(sender: UISwipeGestureRecognizer) {
//        print("handleSwipe")
        if sender.direction == .right{
            SlideAnimationDirection.direction = .left
            print("handle Right Swipe: ")
            let drawerController = DrawerMenuViewController(delegate: self)
            present(drawerController, animated: true)
        }else if sender.direction == .left{
            SlideAnimationDirection.direction = .right
            print("handle Left Swipe: ")
            let drawerController = DrawerMenuViewController(delegate: self)
            present(drawerController, animated: true)
        }
    }

    @IBAction func didTapMenu(_ sender: Any) {
        print("Did Tap Menu called")
        let drawerController = DrawerMenuViewController(delegate: self)
        present(drawerController, animated: true)
    }
}

extension ViewController: DrawerMenuDelegate {
    func drawerMenuOptionSelected(_ option: DrawerMenuOption) {
        switch option {
        case .logout:
            let alert = UIAlertController(title: "Logout", message: "You have successfully logged out", preferredStyle: .alert)
            alert.addAction(.init(title: "Ok", style: .default))
            present(alert, animated: true)
        default:
            setCurrentView(for: option)
        }
    }

    func setCurrentView(for option: DrawerMenuOption) {
        navigationBar.topItem?.title = option.title

        currentController?.view.removeFromSuperview()
        currentController?.removeFromParent()

        let newController = AppScreenViewController(option: option)
        containerView.addSubview(newController.view)
        newController.view.frame = containerView.bounds
        newController.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        addChild(newController)
        currentController = newController
    }
}

