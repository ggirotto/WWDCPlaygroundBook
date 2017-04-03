import UIKit
import Foundation
import SpriteKit

public class Door:SKSpriteNode{
    
    public var xPositionMatrix:Int
    public var yPositionMatrix:Int
    public var doorMap:Map
    private var doorOrientation:enumOrientation
    private var movements:enumMovement
    public var isOpen : Bool
    public var onlyOpenWithKey: Bool
    
    public init(xPosition:Int, yPosition:Int, orientation:enumOrientation, onlyKey:Bool, dMap:Map) {
        
        xPositionMatrix = xPosition
        yPositionMatrix = yPosition
        
        doorMap = dMap
        
        doorOrientation = orientation
        
        movements = enumMovement.a
        
        isOpen = false
        
        onlyOpenWithKey = onlyKey
        
        let position = CGPoint(x: (((doorMap.width%doorMap.matrixSquareSize)/2)+(doorMap.matrixSquareSize*yPosition)-1+18), y: (((doorMap.height%doorMap.matrixSquareSize)/2)+(doorMap.matrixSquareSize*(doorMap.ROWS-1-xPosition))+18))
        
        var imageName : String
        
        switch orientation {
        case enumOrientation.up:
            imageName = "door"
            break
        case enumOrientation.left:
            imageName = "leftdoor"
            break
        case enumOrientation.right:
            imageName = "rightdoor"
            break
        default:
            imageName = ""
            break
        }
        
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: UIColor.clear, size:texture.size())
        self.position = position
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func openDoor(){
        
        self.isOpen = true
        
        let changeFirstSprite = SKAction.run{
            
            switch self.doorOrientation {
             
            case enumOrientation.up:
                self.texture = SKTexture(imageNamed: "dooropen1")
                break
            case enumOrientation.left:
                self.texture = SKTexture(imageNamed: "leftdooropen1")
                break
            case enumOrientation.right:
                self.texture = SKTexture(imageNamed: "rightdooropen1")
                break
            default:
                break
            }
            
        }
        
        let changeSecondSprite = SKAction.run{
            
            switch self.doorOrientation {
                
            case enumOrientation.up:
                self.texture = SKTexture(imageNamed: "dooropen2")
                break
            case enumOrientation.left:
                self.texture = SKTexture(imageNamed: "leftdooropen2")
                break
            case enumOrientation.right:
                self.texture = SKTexture(imageNamed: "rightdooropen2")
                break
            default:
                break
            }
            
        }
        
        let changeThirdSprite = SKAction.run{
            
            switch self.doorOrientation {
                
            case enumOrientation.up:
                self.texture = SKTexture(imageNamed: "dooropen3")
                break
            case enumOrientation.left:
                self.texture = SKTexture(imageNamed: "leftdooropen3")
                break
            case enumOrientation.right:
                self.texture = SKTexture(imageNamed: "rightdooropen3")
                break
            default:
                break
            }
            
        }
        
        let changeFourthSprite = SKAction.run{
            
            switch self.doorOrientation {
                
            case enumOrientation.up:
                self.texture = SKTexture(imageNamed: "dooropen4")
                break
            case enumOrientation.left:
                self.texture = SKTexture(imageNamed: "leftdooropen4")
                break
            case enumOrientation.right:
                self.texture = SKTexture(imageNamed: "rightdooropen4")
                break
            default:
                break
            }
            
        }
    
    let wait = SKAction.wait(forDuration: 0.8)
    
    let cycle = SKAction.sequence([changeFirstSprite, wait, changeSecondSprite, wait, changeThirdSprite, wait, changeFourthSprite])
    
    self.run(cycle)
    
    
    
    
    
    }
    
    public func closeDoor(){
        
        self.isOpen = false
        
        let changeFirstSprite = SKAction.run{
            
            switch self.doorOrientation {
                
            case enumOrientation.up:
                self.texture = SKTexture(imageNamed: "dooropen4")
                break
            case enumOrientation.left:
                self.texture = SKTexture(imageNamed: "leftdooropen4")
                break
            case enumOrientation.right:
                self.texture = SKTexture(imageNamed: "rightdooropen4")
                break
            default:
                break
            }
            
        }
        
        let changeSecondSprite = SKAction.run{
            
            switch self.doorOrientation {
                
            case enumOrientation.up:
                self.texture = SKTexture(imageNamed: "dooropen3")
                break
            case enumOrientation.left:
                self.texture = SKTexture(imageNamed: "leftdooropen3")
                break
            case enumOrientation.right:
                self.texture = SKTexture(imageNamed: "rightdooropen3")
                break
            default:
                break
            }
            
        }
        
        let changeThirdSprite = SKAction.run{
            
            switch self.doorOrientation {
                
            case enumOrientation.up:
                self.texture = SKTexture(imageNamed: "dooropen2")
                break
            case enumOrientation.left:
                self.texture = SKTexture(imageNamed: "leftdooropen2")
                break
            case enumOrientation.right:
                self.texture = SKTexture(imageNamed: "rightdooropen2")
                break
            default:
                break
            }
            
        }
        
        let changeFourthSprite = SKAction.run{
            
            switch self.doorOrientation {
                
            case enumOrientation.up:
                self.texture = SKTexture(imageNamed: "dooropen1")
                break
            case enumOrientation.left:
                self.texture = SKTexture(imageNamed: "leftdooropen1")
                break
            case enumOrientation.right:
                self.texture = SKTexture(imageNamed: "rightdooropen1")
                break
            default:
                break
            }
            
        }
        
        let changeFifthSprite = SKAction.run{
            
            switch self.doorOrientation {
                
            case enumOrientation.up:
                self.texture = SKTexture(imageNamed: "door")
                break
            case enumOrientation.left:
                self.texture = SKTexture(imageNamed: "leftdoor")
                break
            case enumOrientation.right:
                self.texture = SKTexture(imageNamed: "rightdoor")
                break
            default:
                break
            }
            
        }
        
        let wait = SKAction.wait(forDuration: 0.8)
        
        let cycle = SKAction.sequence([changeFirstSprite, wait, changeSecondSprite, wait, changeThirdSprite, wait, changeFourthSprite, wait, changeFifthSprite])
        
        self.run(cycle)
        
        
        
        
        
    }

}
