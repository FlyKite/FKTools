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
        
        let button = FKButton()
        button.setTitle("Normal", for: .normal)
        var gradient = GradientBackground()
        gradient.colors = [UIColor.red, UIColor.yellow]
        button.setBackground(gradient, for: .normal)
        button.frame = CGRect(x: 100, y: 100, width: 100, height: 30)
        button.addTarget(self, action: #selector(buttonClicked), for: .touchUpInside)
        self.view.addSubview(button)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @objc private func buttonClicked() {
        let panel = AlertController()
        self.present(panel, animated: true, completion: nil)
    }

}

class AlertController: UIViewController, FloatingPanel {
    
    private let container: UIView = UIView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        container.backgroundColor = .white
        container.frame = .zero
        container.center = view.center
        view.addSubview(container)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)
        dismiss(animated: true, completion: nil)
    }
    
    func floatingPanelAnimationConfigs() -> AnimationConfig? {
        return nil
    }
    
    func floatingPanelUpdateViews(for animationType: AnimationType) {
        switch animationType {
        case .presenting: container.frame = CGRect(x: 0, y: 0, width: 200, height: 100)
        case .dismissing: container.frame = .zero
        }
        container.center = view.center
    }
    
}
