//
//  DrawerMenuViewController.swift
//  Drawer Menu App
//
//  Created by Ram on 26.09.2020.
//

import UIKit

enum DrawerMenuOption: String, CaseIterable {
    case profile
    case home
    case messages
    case settings
    case logout

    var title: String {
        return rawValue.capitalized
    }

    var icon: UIImage? {
        switch self {
        case .profile:
            return UIImage(named: "profile_picture")
        case .home:
            return UIImage(systemName: "house")
        case .messages:
            return UIImage(systemName: "bubble.left.and.bubble.right")
        case .settings:
            return UIImage(systemName: "gearshape")
        case .logout:
            return UIImage(systemName: "arrow.uturn.left.circle")
        }
    }

}


protocol DrawerMenuDelegate: class {
    func drawerMenuOptionSelected(_ option: DrawerMenuOption)
}

class DrawerMenuViewController: UIViewController {

    @IBOutlet weak var menuTableView: UITableView!
    var currentController: UIViewController?

    static var selectedOption: DrawerMenuOption = .home

    let transitionManager = DrawerTransitionManager()

    weak var delegate: DrawerMenuDelegate?

    init(delegate: DrawerMenuDelegate) {
        super.init(nibName: nil, bundle: nil)
        self.delegate = delegate
        modalPresentationStyle = .custom
        transitioningDelegate = transitionManager
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        menuTableView.register(UINib(nibName: "DrawerMenuCell", bundle: nil), forCellReuseIdentifier: "menuCell")
        menuTableView.register(UINib(nibName: "DrawerProfileCell", bundle: nil), forCellReuseIdentifier: "profileCell")

        setSelectedOption()
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePanGesture(_:)))
        view.addGestureRecognizer(panGesture)
        
    }
    
    @objc func handlePanGesture(_ recognizer: UIPanGestureRecognizer) {
        let translation = recognizer.translation(in: view)
        
        switch recognizer.state {
        case .changed:
            // Move the view horizontally by adjusting its center based on the gesture translation
            let newX = view.center.x + translation.x
            let newY = view.center.y
            view.center = CGPoint(x: newX, y: newY)
            
            // Reset translation to avoid cumulative changes
            recognizer.setTranslation(.zero, in: view)
            
        case .ended:
            // Determine whether to close or open the drawer based on its current position
            if view.frame.origin.x < -UIScreen.main.bounds.width / 4 {
                // Close the drawer
                print("Right swiped called")
                
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin.x = -UIScreen.main.bounds.width
                }
                self.dismiss(animated: false, completion: nil)
                presentedViewController?.dismiss(animated: true)
            }
            else {
                // Open the drawer
                UIView.animate(withDuration: 0.3) {
                    self.view.frame.origin.x = 0
                }
                self.dismiss(animated: false, completion: nil)
                presentedViewController?.dismiss(animated: true)
            }
            
        default:
            break
        }
    }


    private func setSelectedOption() {
        if [DrawerMenuOption.profile, DrawerMenuOption.logout].contains(Self.selectedOption) {
            return
        }
        guard let selectedIndex = DrawerMenuOption.allCases.firstIndex(of: Self.selectedOption) else {
            return
        }

        menuTableView.selectRow(at: IndexPath(row: selectedIndex, section: 0), animated: false, scrollPosition: .top)
    }

}


extension DrawerMenuViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return DrawerMenuOption.allCases.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let option = DrawerMenuOption.allCases[indexPath.row]
        switch option {
        case .profile:
            let cell = tableView.dequeueReusableCell(withIdentifier: "profileCell", for: indexPath)
            return cell
        default:
            let cell = tableView.dequeueReusableCell(withIdentifier: "menuCell", for: indexPath) as! DrawerMenuCell
            cell.titleLabel.text = option.title
            cell.iconImageView.image = option.icon
            return cell
        }
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let option = DrawerMenuOption.allCases[indexPath.row]
        return option == .profile ? 100 : 50
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let option = DrawerMenuOption.allCases[indexPath.row]
        Self.selectedOption = option
        dismiss(animated: true) {
            self.delegate?.drawerMenuOptionSelected(option)
        }
    }


}
