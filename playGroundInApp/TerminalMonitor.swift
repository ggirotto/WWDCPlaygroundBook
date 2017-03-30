import UIKit
import Foundation
import SpriteKit

public class TerminalMonitor: SKSpriteNode {
    
    public init(position:CGPoint){
        
        let texture = SKTexture(imageNamed: "monitorBackground")
        super.init(texture: texture, color: UIColor.black, size: CGSize(width: 100, height: 100))
        self.position = position
        
        self.alpha = 0.7
        self.isHidden = true
        
    }
    
    public func addLabelsToSprite(arrayOfLabels:Array<SKLabelNode> ){
        
        cleanMonitor()
        
        changeLabelsStyle(arrayOfLabels: arrayOfLabels)
        
        calculateMonitorSize(arrayOfLabels: arrayOfLabels)
        
        var yPoint = Double(self.anchorPoint.y+(self.frame.height/2))-20
        
        for label in arrayOfLabels{
            
            label.position = CGPoint(x: Double(-(self.size.width*0.5))+15, y: yPoint)
            self.addChild(label)
            yPoint -= 20
            
            
        }
        
        
    }
    
    public func cleanMonitor(){
        
        self.removeAllChildren()
        
    }
    
    public func fadeInMonitor(){
        self.alpha = 0.0
        
        for childLabel in self.children{
            childLabel.alpha = 0.0
        }
        isHidden = false
        self.run(SKAction.fadeIn(withDuration: 1.5))
        
        for childLabel in self.children{
            childLabel.run(SKAction.fadeIn(withDuration: 1.5))
        }
    }
    
    public func makeMonitorVisible(){
        isHidden = false
    }
    
    public func makeMonitorHidden(){
        isHidden = true
    }
    
    public func changeLabelsStyle(arrayOfLabels:Array<SKLabelNode>){
        
        for label in arrayOfLabels {
            label.fontSize = 12
            label.fontName = "Menlo"
            label.fontColor = SKColor.green
            label.horizontalAlignmentMode = .left
        }
        
    }
    
    public func calculateMonitorSize(arrayOfLabels:Array<SKLabelNode>){
        
        var totalHeight = 0
        var numberOfLabels = 0
        var totalWidth = 0
        
        for label in arrayOfLabels{
            
            numberOfLabels += 1
            totalHeight += Int(label.frame.size.height)
            
            if Int(label.frame.size.width) > totalWidth {
                totalWidth = Int(label.frame.size.width)
            }
            
        }
        totalWidth += 30
        numberOfLabels *= 11
        totalHeight = totalHeight + numberOfLabels
        
        let newSize = CGSize(width: totalWidth, height: totalHeight)
        self.size = newSize
        
        setMonitorPosition(height:totalHeight)
        
    }
    
    public func setMonitorPosition(height: Int){
        
        self.position.y += CGFloat(20+(height/2))
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
