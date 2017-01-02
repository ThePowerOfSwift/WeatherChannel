import UIKit

class DetailBackgroundView: UIView {
    
    override func draw(_ rect: CGRect) {
        //// Color Declarations
        let lightPurple: UIColor = UIColor(red: 0.377, green: 0.075, blue: 0.778, alpha: 1.000)
        let darkPurple: UIColor = UIColor(red: 0.060, green: 0.036, blue: 0.202, alpha: 1.000)
        
        // the current graphic context
        let context = UIGraphicsGetCurrentContext()
        
        //// Gradient Declarations
        // 第3引数の 0,1は決まっている
        let purpleGradient = CGGradient(colorsSpace: CGColorSpaceCreateDeviceRGB(), colors: [lightPurple.cgColor, darkPurple.cgColor] as CFArray, locations: [0, 1])
        
        //// Background Drawing
        let backgroundPath = UIBezierPath(rect: CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height))
        
        // make a copy of the current graphic context
        context?.saveGState()
        
        backgroundPath.addClip()
        
        context?.drawLinearGradient(purpleGradient!,
            
            // 最初の色が始まる位置
            start: CGPoint(x: 160, y: 0),
            
            // 最初の色が終わる位置(次の色が始まる位置）
            end: CGPoint(x: 160, y: 568),
            
            options: [.drawsBeforeStartLocation, .drawsAfterEndLocation])
        
        
        //// Sun Path
        
        let circleOrigin = CGPoint(x: 0, y: 0.80 * self.frame.height)
        let circleSize = CGSize(width: self.frame.width, height: 0.65 * self.frame.height)
        
        let pathStrokeColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 0.390)
        let pathFillColor = UIColor(red: 1.000, green: 1.000, blue: 1.000, alpha: 0.100)
        
        
        //// Sun Drawing
        let sunPath = UIBezierPath(ovalIn: CGRect(x: circleOrigin.x, y: circleOrigin.y, width: circleSize.width, height: circleSize.height))
        pathFillColor.setFill()
        sunPath.fill()
        pathStrokeColor.setStroke()
        sunPath.lineWidth = 1
        context?.saveGState()
        sunPath.setLineDash([2, 2], count: 2, phase: 0)
        sunPath.stroke()
        context?.restoreGState()
    }
}
