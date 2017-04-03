//
//  Torch.swift
//  playGroundInApp
//
//  Created by Guilherme Girotto on 29/03/17.
//  Copyright © 2017 Guilherme Girotto. All rights reserved.
//

import UIKit
import Foundation
import SpriteKit

public class Torch: SKSpriteNode{
    
    public var xPositionMatrix:Int
    public var yPositionMatrix:Int
    public var torchMap:Map
    public var movements:enumMovement
    private var torchOrientation:enumOrientation
    
    
    public init(xPosition:Int, yPosition:Int, orientation:enumOrientation, tMap:Map) {
        
        xPositionMatrix = xPosition
        yPositionMatrix = yPosition
        
        torchMap = tMap
        
        movements = enumMovement.a
        
        torchOrientation = orientation
        
        var imageName : String
        
        switch orientation {
        case enumOrientation.upleft:
            imageName = "topleftfire"
            break
        case enumOrientation.upright:
            imageName = "toprightfire"
            break
        case enumOrientation.downleft:
            imageName = "downleftfire"
            break
        case enumOrientation.downright:
            imageName = "downrightfire"
            break
        default:
            imageName = ""
            break
        }
        
        let texture = SKTexture(imageNamed: imageName)
        super.init(texture: texture, color: UIColor.clear, size:texture.size())
        
        let positionAdjustment = setTorchPosition(torchMap:tMap, torchOrientation: orientation, xPosition: xPosition, yPosition:yPosition)
        
        self.position = CGPoint(x: (((torchMap.width%torchMap.matrixSquareSize)/2)+(torchMap.matrixSquareSize*yPosition)-1+positionAdjustment.0), y: (((torchMap.height%torchMap.matrixSquareSize)/2)+(torchMap.matrixSquareSize*(torchMap.ROWS-1-xPosition))+positionAdjustment.1))
        
        torchMovement()
    }
    
    public func setTorchPosition(torchMap:Map, torchOrientation:enumOrientation, xPosition:Int,yPosition:Int) -> (Int,Int){
        
        switch torchOrientation {
        case enumOrientation.upleft:
            if let leftObject = torchMap.thereIsAWall(x: xPosition, y:yPosition-1 ) {
                if leftObject.wallOrientation == enumOrientation.left{
                    return (3,18)
                }else if leftObject.wallOrientation == enumOrientation.up{
                    return (18,18)
                }else if leftObject.wallOrientation == enumOrientation.right{
                    return (18,18)
                }
            }
            break
        case enumOrientation.upright:
            if let leftObject = torchMap.thereIsAWall(x: xPosition, y:yPosition+1 ) {
                if leftObject.wallOrientation == enumOrientation.left{
                    return (18,18)
                }else if leftObject.wallOrientation == enumOrientation.up{
                    return (18,18)
                }else if leftObject.wallOrientation == enumOrientation.right{
                    return (33,18)
                }
            }
            break
        case enumOrientation.downleft:
            if let leftObject = torchMap.thereIsAWall(x: xPosition, y:yPosition-1 ) {
                if leftObject.wallOrientation == enumOrientation.left{
                    return (3,18)
                }else if leftObject.wallOrientation == enumOrientation.up{
                    return (18,18)
                }else if leftObject.wallOrientation == enumOrientation.right{
                    return (18,18)
                }
            }
            break
        case enumOrientation.downright:
            if let leftObject = torchMap.thereIsAWall(x: xPosition, y:yPosition+1 ) {
                if leftObject.wallOrientation == enumOrientation.left{
                    return (18,18)
                }else if leftObject.wallOrientation == enumOrientation.up{
                    return (18,18)
                }else if leftObject.wallOrientation == enumOrientation.right{
                    return (33,18)
                }
            }
            break
        default:
            return (18,18)
            break
        }
        return (18,18)
        
    }
    
    private func torchMovement(){
        
        
        let changeSprite = SKAction.run {
            
            switch self.torchOrientation {
                
            case enumOrientation.upleft:
                switch self.movements {
                    
                case enumMovement.a:
                    self.texture = SKTexture(imageNamed: "topleftfire2")
                    self.movements = enumMovement.b
                    break
                case enumMovement.b:
                    self.texture = SKTexture(imageNamed: "topleftfire3")
                    self.movements = enumMovement.c
                    break
                case enumMovement.c:
                    self.texture = SKTexture(imageNamed: "topleftfire")
                    self.movements = enumMovement.a
                    break
                default:
                    break
                }
                
                break
                
            case enumOrientation.upright:
                switch self.movements {
                    
                case enumMovement.a:
                    self.texture = SKTexture(imageNamed: "toprightfire2")
                    self.movements = enumMovement.b
                    break
                case enumMovement.b:
                    self.texture = SKTexture(imageNamed: "toprightfire3")
                    self.movements = enumMovement.c
                    break
                case enumMovement.c:
                    self.texture = SKTexture(imageNamed: "toprightfire")
                    self.movements = enumMovement.a
                    break
                default:
                    break
                }
                
                break
                
            case enumOrientation.downleft:
                switch self.movements {
                    
                case enumMovement.a:
                    self.texture = SKTexture(imageNamed: "downleftfire2")
                    self.movements = enumMovement.b
                    break
                case enumMovement.b:
                    self.texture = SKTexture(imageNamed: "downleftfire3")
                    self.movements = enumMovement.c
                    break
                case enumMovement.c:
                    self.texture = SKTexture(imageNamed: "downleftfire")
                    self.movements = enumMovement.a
                    break
                default:
                    break
                }
                
                break
                
            case enumOrientation.downright:
                switch self.movements {
                    
                case enumMovement.a:
                    self.texture = SKTexture(imageNamed: "downrightfire2")
                    self.movements = enumMovement.b
                    break
                case enumMovement.b:
                    self.texture = SKTexture(imageNamed: "downrightfire3")
                    self.movements = enumMovement.c
                    break
                case enumMovement.c:
                    self.texture = SKTexture(imageNamed: "downrightfire")
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
        
        let wait = SKAction.wait(forDuration: 0.2)
        
        let cycle = SKAction.sequence([changeSprite, wait])
        
        let repeatActions = SKAction.repeatForever(cycle)
        
        self.run(repeatActions)
        
        
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
