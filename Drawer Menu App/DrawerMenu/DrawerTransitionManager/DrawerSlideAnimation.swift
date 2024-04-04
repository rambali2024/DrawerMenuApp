//
//  DrawerSlideAnimation.swift
//  Drawer Menu App
//
//  Created by Ram on 26.09.2020.
//

/*
import UIKit

class DrawerSlideAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    var isPresenting: Bool = true

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let key: UITransitionContextViewControllerKey = isPresenting ? .to : .from
        guard let presentedController = transitionContext.viewController(forKey: key) else {
            return
        }

        let containerView = transitionContext.containerView
        let presentedFrame = transitionContext.finalFrame(for: presentedController)
        let dismissedFrame = presentedFrame.offsetBy(dx: -presentedFrame.width, dy: 0)

        if isPresenting {
            containerView.addSubview(presentedController.view)
        }

        let duration = transitionDuration(using: transitionContext)
        let wasCancelled = transitionContext.transitionWasCancelled

        let fromFrame = isPresenting ? dismissedFrame : presentedFrame
        let toFrame = isPresenting ? presentedFrame : dismissedFrame

        presentedController.view.frame = fromFrame

        UIView.animate(withDuration: duration) {
            presentedController.view.frame = toFrame
        } completion: { (_) in
            transitionContext.completeTransition(!wasCancelled)
        }
    }
}
*/



import UIKit

class DrawerSlideAnimation: NSObject, UIViewControllerAnimatedTransitioning {

    var isPresenting: Bool = true
//    var direction: SlideDirection = .left // Direction of the slide animation

    let direction = SlideAnimationDirection.direction

    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return 0.5
    }

    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {

        let key: UITransitionContextViewControllerKey = isPresenting ? .to : .from
        guard let presentedController = transitionContext.viewController(forKey: key) else {
            return
        }

        let containerView = transitionContext.containerView
        let presentedFrame = transitionContext.finalFrame(for: presentedController)

        print("direction: \(direction)")
        let dismissedFrame = CGRect(x: direction == .left ? presentedFrame.origin.x - presentedFrame.width : presentedFrame.origin.x + presentedFrame.width,
                                    y: presentedFrame.origin.y,
                                    width: presentedFrame.width,
                                    height: presentedFrame.height)

        if isPresenting {
            containerView.addSubview(presentedController.view)
        }

        let duration = transitionDuration(using: transitionContext)
        let wasCancelled = transitionContext.transitionWasCancelled

        let fromFrame = isPresenting ? dismissedFrame : presentedFrame
        let toFrame = isPresenting ? presentedFrame : dismissedFrame

        presentedController.view.frame = fromFrame

        UIView.animate(withDuration: duration) {
            presentedController.view.frame = toFrame
        } completion: { (_) in
            transitionContext.completeTransition(!wasCancelled)
        }
    }
}

