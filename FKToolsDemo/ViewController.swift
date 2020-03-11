//
//  ViewController.swift
//  FKToolsDemo
//
//  Created by 风筝 on 2017/10/11.
//  Copyright © 2017年 Doge Studio. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        let attrText = NSMutableAttributedString()
        
        attrText.addAttributes([.foregroundColor: 0x03A9F4.rgbColor,
                                .font: UIFont.systemFont(ofSize: 16)],
                               range: NSRange(location: 0, length: attrText.length))
        
        attrText.set()
            .foregroundColor(0x03A9F4.rgbColor)
            .font(UIFont.systemFont(ofSize: 16))
            .end()
            
        let button = FKButton()
        button.setTitle("Alert", for: .normal)
        var gradient = GradientBackground()
        gradient.colors = [UIColor.red, UIColor.yellow]
        button.setBackground(gradient, for: .normal)
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 30)
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        self.view.addSubview(button)
        
        let button2 = FKButton()
        button2.setTitle("Sheet", for: .normal)
        button2.setBackground(gradient, for: .normal)
        button2.frame = CGRect(x: 100, y: 160, width: 100, height: 30)
        button2.addTarget(self, action: #selector(button2Clicked), for: .touchUpInside)
        self.view.addSubview(button2)
    }
    
    private let label: UILabel = {
        return UILabel()
    }()
    
    private func setupViews() {
        configLabel()
    }
    
    private func configLabel() {
        label.font = UIFont.systemFont(ofSize: 12)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc private func buttonClicked() {
        let panel = AlertController()
        present(panel, animated: true, completion: nil)
    }

    @objc private func button2Clicked() {
        let sheet = BottomSheet()
        present(sheet, animated: true, completion: nil)
    }

}

class AlertController: UIViewController, FloatingPanel {
    
    private let container: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        container.frame = CGRect(x: view.bounds.width / 2, y: view.bounds.height / 2, width: 0, height: 0)
        container.backgroundColor = .white
        view.addSubview(container)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func handleTap(_ tap: UITapGestureRecognizer) {
        if tap.state == .ended {
            dismiss(animated: true, completion: nil)
        }
    }
    
    func floatingPanelAnimationConfigs() -> AnimationConfig {
        var config = AnimationConfig()
        config.maskType = .color(color: 0x03A9F4.rgbColor(alpha: 0.3))
//        config.targetFrame = CGRect(x: 50, y: 300, width: 300, height: 300)
        return config
    }
    
    func floatingPanelUpdateViews(for transitionType: TransitionType, duration: TimeInterval, completeCallback: @escaping () -> Void) {
        UIView.animate(withDuration: duration, animations: {
            switch transitionType {
            case .presenting: self.container.frame = CGRect(x: self.view.bounds.width / 2 - 100,
                                                            y: self.view.bounds.height / 2 - 50,
                                                            width: 200,
                                                            height: 100)
            case .dismissing: self.container.frame = CGRect(x: self.view.bounds.width / 2,
                                                            y: self.view.bounds.height / 2,
                                                            width: 0,
                                                            height: 0)
            }
        }) { (finished) in
            completeCallback()
        }
    }
    
}

class BottomSheet: UIViewController, FloatingPanel {
    
    private let container: UIView = UIView()
    
    private var percentTransition: UIPercentDrivenInteractiveTransition?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        container.frame = CGRect(x: 0,
                                 y: view.bounds.height,
                                 width: view.bounds.width,
                                 height: view.bounds.height / 3)
        container.backgroundColor = .white
        view.addSubview(container)
        
        let pan = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        container.addGestureRecognizer(pan)
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        view.addGestureRecognizer(tap)
    }
    
    @objc private func handleTap(_ tap: UITapGestureRecognizer) {
        if tap.state == .ended {
            dismiss(animated: true, completion: nil)
        }
    }
    
    @objc private func handlePan(_ pan: UIPanGestureRecognizer) {
        if pan.state == .began {
            let percent = UIPercentDrivenInteractiveTransition()
            percentTransition = percent
            dismiss(with: percent, animated: true, completion: nil)
        } else {
            var progress = pan.translation(in: view).y / container.bounds.height
            progress = progress < 0 ? 0 : (progress > 1 ? 1 : progress)
            
            if pan.state == .changed {
                percentTransition?.update(progress)
            } else if pan.state == .ended || pan.state == .cancelled {
                let vx = pan.velocity(in: view).y
                if vx > 800 {
                    percentTransition?.finish()
                } else if vx < -800 {
                    percentTransition?.cancel()
                } else if progress > 0.33 {
                    percentTransition?.finish()
                } else {
                    percentTransition?.cancel()
                }
                percentTransition = nil
            }
        }
    }
    
    func floatingPanelAnimationConfigs() -> AnimationConfig {
        return .default
    }
    
    func floatingPanelUpdateViews(for animationType: TransitionType, duration: TimeInterval, completeCallback: @escaping () -> Void) {
        UIView.animate(withDuration: duration, animations: {
            var frame = self.container.frame
            switch animationType {
            case .presenting: frame.origin.y = self.view.bounds.height - frame.height
            case .dismissing: frame.origin.y = self.view.bounds.height
            }
            self.container.frame = frame
        }) { (finished) in
            completeCallback()
        }
    }
}
