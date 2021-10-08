//
//  Tomodachi.swift
//  Tomo
//
//  Created by Dayem Saeed on 9/26/21.
//

import Foundation
import SpriteKit

class Tomodachi: SKScene {
    override func didMove(to view: SKView) {
        physicsBody = SKPhysicsBody(edgeLoopFrom: frame)
    }
    
    override init(size: CGSize) {
        super.init(size: size);
        self.backgroundColor = .clear;
        let tomodachi = SKSpriteNode(imageNamed: "Fox-front");
        tomodachi.position = CGPoint(x: 100, y: 100);
        tomodachi.size = CGSize(width: 250, height: 250);
        self.addChild(tomodachi);
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
