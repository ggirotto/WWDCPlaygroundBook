import UIKit
import Foundation
import SpriteKit

public class Wall: SKSpriteNode{
    
    public var xPositionMatrix:Int
    public var yPositionMatrix:Int
    public var wallMap:Map
    
    
    public init(xPosition:Int, yPosition:Int, orientation:enumOrientation, wMap:Map) {
        
        xPositionMatrix = xPosition
        yPositionMatrix = yPosition
        
        wallMap = wMap
        
        let position = CGPoint(x: (((wallMap.width%wallMap.matrixSquareSize)/2)+(wallMap.matrixSquareSize*yPosition)-1+18), y: (((wallMap.height%wallMap.matrixSquareSize)/2)+(wallMap.matrixSquareSize*(wallMap.ROWS-1-xPosition))+18))
        
        var texture : SKTexture
        
        switch orientation {
        case enumOrientation.left:
            texture = SKTexture(imageNamed: "leftwall")
            break
        case enumOrientation.right:
            texture = SKTexture(imageNamed: "rightwall")
            break
        default:
            texture = SKTexture(imageNamed: "wall")
        }
        
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: wallMap.matrixSquareSize, height: wallMap.matrixSquareSize))
        self.position = position
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
