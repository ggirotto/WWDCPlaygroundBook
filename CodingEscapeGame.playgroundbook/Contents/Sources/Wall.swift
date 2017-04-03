import UIKit
import Foundation
import SpriteKit

public class Wall: SKSpriteNode{
    
    public var xPositionMatrix:Int
    public var yPositionMatrix:Int
    public var wallMap:Map
    public var wallOrientation : enumOrientation
    
    
    public init(xPosition:Int, yPosition:Int, orientation:enumOrientation, wMap:Map) {
        
        xPositionMatrix = xPosition
        yPositionMatrix = yPosition
        
        wallMap = wMap
        
        wallOrientation = orientation
        
        let position = CGPoint(x: (((wallMap.width%wallMap.matrixSquareSize)/2)+(wallMap.matrixSquareSize*yPosition)-1+18), y: (((wallMap.height%wallMap.matrixSquareSize)/2)+(wallMap.matrixSquareSize*(wallMap.ROWS-1-xPosition))+18))
        
        var imageName : String
        
        switch orientation {
        case enumOrientation.left:
            imageName = "leftwall"
            break
        case enumOrientation.right:
            imageName = "rightwall"
            break
        default:
            imageName = "wall"
        }
        
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: UIColor.clear, size:texture.size())
        
        self.position = position
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
