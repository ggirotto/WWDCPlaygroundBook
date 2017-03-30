import UIKit
import Foundation
import SpriteKit

public class Key:SKSpriteNode{
    
    public var keyName : String
    public var xPositionMatrix:Int
    public var yPositionMatrix:Int
    public var keyMap:Map
    
    public init(nameOfKey:String, xPosition:Int, yPosition:Int, pMap:Map) {
        
        keyName = nameOfKey
        
        xPositionMatrix = xPosition
        yPositionMatrix = yPosition
        
        keyMap = pMap
        
        let position = CGPoint(x: (((keyMap.width%keyMap.matrixSquareSize)/2)+(keyMap.matrixSquareSize*yPosition)-1+16), y: (((keyMap.height%keyMap.matrixSquareSize)/2)+(keyMap.matrixSquareSize*(keyMap.ROWS-1-xPosition))+(keyMap.matrixSquareSize/2)))
        
        let texture = SKTexture(imageNamed: "key")
        super.init(texture: texture, color: UIColor.clear, size: CGSize(width: keyMap.matrixSquareSize, height: keyMap.matrixSquareSize))
        self.position = position
        
    }
    
    public func removeKeyFromMap(){
        
        let action = SKAction.removeFromParent()
        
        self.run(action)
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
