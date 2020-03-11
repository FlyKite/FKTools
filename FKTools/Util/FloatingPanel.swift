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
    
    /// 遮罩类型
    enum MaskType {
        /// 无遮罩
        case none
        /// 黑色半透明遮罩
        case black(alpha: CGFloat)
        /// 指定颜色的遮罩
        case color(color: UIColor)
    }
    
    /// present时的动画持续时间，默认值为0.35秒
    var duration: TimeInterval = 0.35
    /// dismiss时的动画持续时间，若为nil则使用duration的值
    var durationForDismissing: TimeInterval?
    /// 遮罩类型，默认值是alpha值为0.5的半透明黑色，
    var maskType: MaskType = .black(alpha: 0.5)
    
    /// 可调整展示区域，默认nil不调整
    var targetFrame: CGRect?
    /// 展示样式，默认为overFullScreen，可根据需求调整
    var presentationStyle: UIModalPresentationStyle = .overFullScreen
    
    init() { }
}

public typealias TransitionComplete = (_ isCancelled: Bool) -> Void

public protocol FloatingPanel: UIViewController {
    /// 通过该方法返回动画配置，若返回nil则使用默认值
    ///
    /// - Returns: 浮动面板显示隐藏时的动画配置
    func floatingPanelAnimationConfigs() -> AnimationConfig?
    
    /// 通过该方法更新浮动面板显示和隐藏时的约束值或其他属性
    ///
    /// - Parameter type: 当前要执行的动画类型
    func floatingPanelUpdateViews(for animationType: AnimationType, duration: TimeInterval, completeCallback: @escaping () -> Void)
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
    
    private lazy var maskView: UIView = UIView()
    
    private lazy var config: AnimationConfig = {
        return floatingPanel.floatingPanelAnimationConfigs() ?? AnimationConfig()
    }()
    
    func transitionDuration(using transitionContext: UIViewControllerContextTransitioning?) -> TimeInterval {
        return config.duration
    }
    
    func animateTransition(using transitionContext: UIViewControllerContextTransitioning) {
        guard let view = transitionContext.view(forKey: animationType.viewKey) else {
            return
        }
        let container = transitionContext.containerView
        if let targetFrame = config.targetFrame {
            container.frame = targetFrame
        }
        view.frame = container.bounds
        updateMask(for: animationType, container: container)
        container.addSubview(view)
        
        let duration: TimeInterval
        switch animationType {
        case .presenting: duration = config.duration
        case .dismissing: duration = config.durationForDismissing ?? config.duration
        }
        
        floatingPanel.floatingPanelUpdateViews(for: animationType, duration: duration) {
            transitionContext.completeTransition(!transitionContext.transitionWasCancelled)
        }
    }
    
    private func updateMask(for animationType: AnimationType, container: UIView) {
        if case .none = config.maskType {
            return
        }
        switch animationType {
        case .presenting:
            maskView.backgroundColor = config.maskType.maskColor
            maskView.frame = container.bounds
            maskView.alpha = 0
            container.addSubview(maskView)
            UIView.animate(withDuration: config.duration) {
                self.maskView.alpha = 1
            }
        case .dismissing:
            UIView.animate(withDuration: config.durationForDismissing ?? config.duration) {
                self.maskView.alpha = 0
            }
        }
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

private extension AnimationConfig.MaskType {
    var maskColor: UIColor {
        switch self {
        case .none: return .clear
        case let .black(alpha): return UIColor(white: 0, alpha: alpha)
        case let .color(color): return color
        }
    }
}
