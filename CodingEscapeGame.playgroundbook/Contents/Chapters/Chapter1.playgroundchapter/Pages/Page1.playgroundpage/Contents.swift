
//#-hidden-code

import PlaygroundSupport

let page = PlaygroundPage.current

func openNearestDoors(){
    
    if let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy{
        proxy.send(PlaygroundValue.string("openDoors"))
    }
    
}

func turnOffNearestCameras(){
    
    if let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy{
        proxy.send(PlaygroundValue.string("turnOffNearestCameras"))
    }
    
    
}

func turnAlarmsOn(){
    
    if let proxy = page.liveView as? PlaygroundRemoteLiveViewProxy{
        proxy.send(PlaygroundValue.string("turnAlarmsOn"))
    }
    
    
}
//#-code-completion(everything, hide)
//#-code-completion(identifier, show, openNearestDoors(), turnOffNearestCameras(), turnAlarmsOn())
//#-end-hidden-code
/*:
 Here we start. Interact with the **objects** and try to escape from the dungeon. Be careful with the enemies and use the **Terminal**, it can be very useful. You should use the area below to type Terminal `commands` and somehow bypass obstacles. Good luck Player, you will **need** it.
 */
//#-hidden-code
//#-end-hidden-code
//#-editable-code



//#-end-editable-code
