import UIKit

public extension UIView {
    
    //MARK: - Constants
    enum Constants {
        static let shimmerLayerName = "shimmerLayer"
        
        static let animationKeyPath = "locations"
        static let animationKeyName = "shimmerAnimation"
        
        static let animationDuration: CFTimeInterval = 1.2
        
        static let startLocations: [NSNumber] = [-1.0, -0.5, 0.0]
        static let endLocations: [NSNumber]   = [1.0, 1.5, 2.0]
        
        static let gradientLocations: [NSNumber] = [0.0, 0.5, 1.0]
        
        static let startPoint = CGPoint(x: 0.0, y: 0.5)
        static let endPoint   = CGPoint(x: 1.0, y: 0.5)
        
        static let shimmerColors: [CGColor] = [
            UIColor.systemGray5.cgColor,
            UIColor.systemGray4.cgColor,
            UIColor.systemGray5.cgColor
        ]
    }
    
    //MARK: - Functionf for shimmer
    func startShimmer() {
        //не добавляем второй shimmer
        if layer.sublayers?.contains(where: { $0.name == Constants.shimmerLayerName }) == true {
            return
        }
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.name = Constants.shimmerLayerName
        gradientLayer.frame = bounds
        gradientLayer.cornerRadius = layer.cornerRadius
        gradientLayer.masksToBounds = true
        
        gradientLayer.colors = Constants.shimmerColors
        gradientLayer.locations = Constants.gradientLocations
        gradientLayer.startPoint = Constants.startPoint
        gradientLayer.endPoint = Constants.endPoint
        
        let animation = CABasicAnimation(keyPath: Constants.animationKeyPath)
        animation.fromValue = Constants.startLocations
        animation.toValue = Constants.endLocations
        animation.duration = Constants.animationDuration
        animation.repeatCount = .infinity
        
        gradientLayer.add(animation, forKey: Constants.animationKeyName)
        layer.addSublayer(gradientLayer)
    }
    
    func stopShimmer() {
        layer.sublayers?
            .filter { $0.name == Constants.shimmerLayerName }
            .forEach { $0.removeFromSuperlayer() }
    }
    
    func updateShimmerFrame() {
        layer.sublayers?
            .filter { $0.name == Constants.shimmerLayerName }
            .forEach { $0.frame = bounds }
    }
}
