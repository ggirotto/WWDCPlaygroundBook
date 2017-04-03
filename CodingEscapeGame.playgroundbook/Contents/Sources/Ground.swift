import UIKit
import Foundation
import SpriteKit

public class Ground:SKSpriteNode{
    
    public static let getInstance = Ground()
    
    public init(){
        
        let texture = SKTexture(imageNamed: "ground")
        super.init(texture: texture, color: UIColor.clear, size:texture.size())
        
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
