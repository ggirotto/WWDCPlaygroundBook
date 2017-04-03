import UIKit
import Foundation
import SpriteKit

public class Alarm:SKSpriteNode{
    
    public var xPositionMatrix:Int
    public var yPositionMatrix:Int
    public var alarmMap:Map
    private var movements:enumMovement
    private var alarmOrientation:enumOrientation
    
    public init(xPosition: Int, yPosition: Int, orientation: enumOrientation, aMap:Map) {
        
        xPositionMatrix = xPosition
        yPositionMatrix = yPosition
        
        alarmMap = aMap
        
        movements = enumMovement.a
        
        alarmOrientation = orientation
        
        let position = CGPoint(x: (((alarmMap.width%alarmMap.matrixSquareSize)/2)+(alarmMap.matrixSquareSize*yPosition)-1+18), y: (((alarmMap.height%alarmMap.matrixSquareSize)/2)+(alarmMap.matrixSquareSize*(alarmMap.ROWS-1-xPosition))+18))
        
        var imageName : String
        
        // Change the alarm texture based on the alarm location
        switch orientation {
        case enumOrientation.down:
            imageName = "alarm1"
            break
        case enumOrientation.up:
            imageName = "alarm1up"
            break
        default:
            imageName = ""
        }
        
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: UIColor.clear, size:texture.size())
        self.position = position
        
    }
    
    // Turn the alarm on: change the sprites to simulate light movement
    public func playAlarmOn(){
        
        let changeSprite = SKAction.run {
            
            switch self.alarmOrientation {
                
            case enumOrientation.down:
                switch self.movements {
                    
                    case enumMovement.a:
                        self.texture = SKTexture(imageNamed: "alarm2")
                        self.movements = enumMovement.b
                        break
                    case enumMovement.b:
                        self.texture = SKTexture(imageNamed: "alarm3")
                        self.movements = enumMovement.c
                        break
                    case enumMovement.c:
                        self.texture = SKTexture(imageNamed: "alarm1")
                        self.movements = enumMovement.a
                        break
                    default:
                        break
                }
                
                break
                
            case enumOrientation.up:
                switch self.movements {
                    
                case enumMovement.a:
                    self.texture = SKTexture(imageNamed: "alarm2up")
                    self.movements = enumMovement.b
                    break
                case enumMovement.b:
                    self.texture = SKTexture(imageNamed: "alarm3up")
                    self.movements = enumMovement.c
                    break
                case enumMovement.c:
                    self.texture = SKTexture(imageNamed: "alarm1up")
                    self.movements = enumMovement.a
                    break
                default:
                    break
                }
                
                break
                
            default:
                break
            }
            
            
            
        }
        
        let stopAlarmMovement = SKAction.run {
            
            self.removeAction(forKey: "alarmMovement")
            self.texture = SKTexture(imageNamed: "alarm1up")
            
        }
        
        let wait = SKAction.wait(forDuration: 0.2)
        
        let cycle = SKAction.sequence([changeSprite, wait])
        
        let repeatActions = SKAction.repeatForever(cycle)
        
        self.run(repeatActions, withKey:"alarmMovement")
        
        
        let alarmSound = SKAction.playSoundFileNamed("alarm.mp3", waitForCompletion: true)
        
        
        
        
        let wait10 = SKAction.wait(forDuration: 10)
        
        let secondCycle = SKAction.sequence([wait10,stopAlarmMovement])
        
        self.run(alarmSound)
        
        self.run(secondCycle)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
