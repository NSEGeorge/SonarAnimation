//: A UIKit based Playground for presenting user interface

import UIKit
import PlaygroundSupport

class MyViewController : UIViewController {
    override func loadView() {
        let view = UIView()
        view.backgroundColor = .white
        
        let sonarView = SonarView(frame: CGRect(x: 145,
                                                y: 300,
                                                width: 100, height: 100))

        view.addSubview(sonarView)
        
        sonarView.startAnimation(CACurrentMediaTime())
        sonarView.startAnimation(CACurrentMediaTime() + 1)
        sonarView.startAnimation(CACurrentMediaTime() + 2)
        
        self.view = view
    }
}


class SonarView: UIView {
    var color = UIColor.blue
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func startAnimation(_ beginTime: CFTimeInterval) {
        // Animated paths
        let beginPath = UIBezierPath(arcCenter: self.center,
                                     radius: 1,
                                     startAngle: 0,
                                     endAngle: CGFloat.pi*2,
                                     clockwise: true)
        
        let endPath = UIBezierPath(arcCenter: self.center,
                                   radius: bounds.height/2,
                                   startAngle: 0,
                                   endAngle: CGFloat.pi*2,
                                   clockwise: true)
        // Configure shape layer
        let shapeLayer = CAShapeLayer()
        shapeLayer.anchorPoint = .zero
        shapeLayer.strokeColor = color.cgColor
        shapeLayer.fillColor = color.cgColor
        shapeLayer.path = beginPath.cgPath
        shapeLayer.bounds = endPath.bounds
        layer.addSublayer(shapeLayer)
        
        // Path animation
        let pathAnimation = CABasicAnimation(keyPath: "path")
        pathAnimation.fromValue = beginPath.cgPath
        pathAnimation.toValue = endPath.cgPath
        
        // Opacity animation
        let opacityAnimation = CABasicAnimation(keyPath: "opacity")
        opacityAnimation.fromValue = 1
        opacityAnimation.toValue = 0
        
        // Group animation
        let animationGroup = CAAnimationGroup()
        animationGroup.beginTime = beginTime
        animationGroup.animations = [pathAnimation, opacityAnimation]
        animationGroup.duration = 3
        animationGroup.repeatCount = Float.greatestFiniteMagnitude
        animationGroup.isRemovedOnCompletion = false
        animationGroup.fillMode = kCAFillModeForwards
        
        shapeLayer.add(animationGroup, forKey: "sonar")
    }
}

// Present the view controller in the Live View window
PlaygroundPage.current.liveView = MyViewController()
