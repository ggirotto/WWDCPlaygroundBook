//
//  ViewController.swift
//  playGroundInApp
//
//  Created by Guilherme Girotto on 29/03/17.
//  Copyright © 2017 Guilherme Girotto. All rights reserved.
//

import UIKit
import Foundation
import SpriteKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        //: Playground - noun: a place where people can play
        
        let scene = Scene(size: CGSize(width: 1332, height: 936))
        let view = self.view as! SKView
        
        view.presentScene(scene)
        
        scene.scaleMode = .aspectFit
        
        
        // Guarda não ta seguindo o alarme: descobrir pq
        // ARRUMAR O TERMINAL
        // bug na hora de andar
        // Quando passar para playeground book : live edit no terminal
        // fazer cutscene
        // DESGIN!
        // Verificar jogabilidade em geral
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

