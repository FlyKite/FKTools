//
//  FloatingPanel.swift
//  FKTools
//
//  Created by FlyKite on 2020/1/3.
//  Copyright © 2020 Doge Studio. All rights reserved.
//

import UIKit

public enum AnimationType {
    case presenting
    case dismissing
}

public struct AnimationConfig {
    var duration: TimeInterval = 0.35
    var maskAlpha: CGFloat = 0.5
    
    init() { }
}

public protocol FloatingPanel: UIViewController {
    /// 通过该方法返回动画配置，若返回nil则使用默认值
    ///
    /// - Returns: 浮动面板显示隐藏时的动画配置
    func floatingPanelAnimationConfigs() -> AnimationConfig?
    
    /// 通过该方法更新浮动面板显示和隐藏时的约束值或其他属性
    ///
    /// - Parameter type: 当前要执行的动画类型
    func floatingPanelUpdateViews(for animationType: AnimationType)
}

extension FloatingPanel where Self: UIViewController {
    /// 隐藏浮动面板（可交互的）
    ///
    /// - Parameters:
    ///   - interactiveTransition: 传入一个交互控制器，在外部通过该对象去控制当前dismiss的进度
    ///   - animated: 是否展示动画
    ///   - completion: dismiss结束的回调
    public func dismiss(with interactiveTransition: UIPercentDrivenInteractiveTransition, animated: Bool, completion: (() -> Void)?) {
        transitioningManager?.interactivePopTransition = interactiveTransition
        dismiss(animated: animated) {
            self.transitioningManager?.interactivePopTransition = nil
        }
    }
}

extension UIViewController {
    public func present(_ floatingPanel: FloatingPanel, animated: Bool, completion: (() -> Void)?) {
        floatingPanel.configFloatingPanelAnimator()
        present(floatingPanel as UIViewController, animated: animated, completion: completion)
    }
}

extension FloatingPanel where Self: UIViewController {
    fileprivate func configFloatingPanelAnimator() {
        modalPresentationStyle = .overFullScreen
        transitioningManager = FloatingPanelTransitioning(floatingPanel: self)
        transitioningDelegate = transitioningManager
    }
}

private var TransitioningManagerKey = "TransitioningManagerKey"
extension FloatingPanel {
    private var transitioningManager: FloatingPanelTransitioning? {
        get {
            return objc_getAssociatedObject(self, &TransitioningManagerKey) as? FloatingPanelTransitioning
        }
        set {
            objc_setAssociatedObject(self, &TransitioningManagerKey, newValue, .OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        }
    }
}

private class FloatingPanelTransitioning: NSObject, UIViewControllerTransitioningDelegate {
    
    var interactivePopTransition: UIPercentDrivenInteractiveTransition?
    let animator: FloatingPanelAnimator
    
    init(floatingPanel: FloatingPanel) {
        animator = FloatingPanelAnimator(floatingPanel: floatingPanel)
    }
    
    func animationController(forPresented presented: UIViewController, presenting: UIViewController, source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.animationType = .presenting
        return animator
    }
    
    func animationController(forDismissed dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        animator.animationType = .dismissing
        return animator
    }
    
    func interactionControllerForDismissal(using animator: UIViewControllerAnimatedTransitioning) -> UIViewControllerInteractiveTransitioning? {
        return interactivePopTransition
    }
    
}

private class FloatingPanelAnimator: NSObject, UIViewControllerAnimatedTransitioning {
    
    unowned var floatingPanel: FloatingPanel
    var animationType: AnimationType = .presenting
    
    init(floatingPanel: FloatingPanel) {
        self.floatingPanel = floatingPanel
    }
    
    private let maskView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        return view
    }()
    
    private lazy var config: AnimationConfig = {
        return floatingPanel.floatingPanelAnimationConfigs() ?? AnimationConfig()
    }()
    
    private var startMaskAlpha: CGFloat {
        switch animationType {
        case .presenting: return 0
        case .dismissing: return config.maskAlpha
        }
    }
    private var targetMaskAlpha: CGFloat {
        switch animationType {
        case .presenting: return config.maskAlpha
        case .dismissing: return 0
        }
    }
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return config.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let view = transitionContext.view(forKey: animationType.viewKey) else {
            return
        }
        let container = transitionContext.containerView
        view.frame = container.bounds
        maskView.frame = container.bounds
        maskView.alpha = startMaskAlpha
        if animationType == .presenting {
            container.addSubview(maskView)
        }
        container.addSubview(view)
        
        view.layoutIfNeeded()
        UIView.animate(withDuration: config.duration, delay: 0, options: .curveEaseOut, animations: {
            self.maskView.alpha = self.targetMaskAlpha
            self.floatingPanel.floatingPanelUpdateViews(for: self.animationType)
            view.layoutIfNeeded()
        }, completion: { (finished) in
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
            if self.animationType == .dismissing && !transitionContext.transitionWasCancelled {
                self.maskView.removeFromSuperview()
            }
        })
    }
}

private extension AnimationType {
    var viewKey: UITransitionContextViewKey {
        switch self {
        case .presenting: return .to
        case .dismissing: return .from
        }
    }
}
