////
////  Gameplay.swift
////  SkyCraft
////
////  Created by Louis Mayco Dillon Wijaya on 18/05/23.
////
//
//import SwiftUI
//import SpriteKit
//import GameKit
//import CoreMotion
//
//
//class GameScene: SKScene, SKPhysicsContactDelegate, ObservableObject {
//    /**
//        GAME MECHANICS
//     */
//    // background
//    let background = SKSpriteNode(imageNamed: "background")
//    
//    // player's aircraft
//    var player = SKSpriteNode()
//    
//    // for Gyro movemenet
//    let motionManager = CMMotionManager()
//    
//    // limit aircraft playin area (manually tuned for iphone 14)
//    var minX: CGFloat = 0
//    var maxX: CGFloat = 750
//    var minY: CGFloat = 30
//    var maxY: CGFloat = 1200
//    
//    // bullets
//    var bulletGun = SKSpriteNode()
//    var bulletShellL = SKSpriteNode()
//    var bulletShellM = SKSpriteNode()
//    var bulletShellR = SKSpriteNode()
//    var bulletDamage = 10.0
//    var enemyFire = SKSpriteNode()
//    
//    // Enemy's attack
//    var incomingGunTimer = Timer()
//    
//    /**
//        GAME DYNAMICS
//     */
//    // Health
//    var playerHealthLabel = SKLabelNode()
//    var playerHealth = 100.0
//    
//    // Ammo
//    var playerAmmoLabel = SKLabelNode()
//    var playerAmmo = 8
//    var AmmoRegenTimer = Timer()
//    // GameOver
//    @Published var gameOver = false
//    
//    
//    
//    
//    struct CBitmask {
//        static let playerAircraft: UInt32 = 0b1
//        static let playerFire: UInt32 = 0b10
//        static let enemyAircraft: UInt32 = 0b100
//        static let enemyFire: UInt32 = 0b1000
//    }
//    
//    
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        // touch to attack function
//        for _ in touches {
//            // Check if ammo still available
//            if playerAmmo > 0 {
//                fireShell()
//                playerAmmo -= 1
//                playerAmmoLabel.text = "Ammo: \(playerAmmo)"
//            }
//            // fire function
////            fireGun()
////            fireShell()
//        }
//    }
//    
//    override func didMove(to view: SKView){
//        // physics world
//        physicsWorld.contactDelegate = self
//        
//        scene?.size = CGSize(width: 750, height: 1350)
//        
//        // Enable background
//        background.position = CGPoint(x: size.width / 2, y: size.height / 2)
//        background.setScale(2)
//        background.zPosition =  1
//        addChild(background)
//        
//        // Enable aircraft
//        makeAircraft(style: aircraftChoice.integer(forKey: "aircraftType"))
//        super.didMove(to: view)
//        
//        // movement using accleremoter
//        if motionManager.isAccelerometerAvailable {
//            // gyro time interval
//            motionManager.accelerometerUpdateInterval = 0.1
//            motionManager.startAccelerometerUpdates()
//        }
//        
//        // For debugging physics
////        incomingGunTimer = .scheduledTimer(timeInterval: 0.7, target: self,
////                                           selector: #selector(incomingGun), userInfo: nil, repeats: true)
//        // For debugging new incoming fire function
//        Timer.scheduledTimer(withTimeInterval: 0.8, repeats: true) { [self] _ in
//            self.incomingFire(type: "Shells", x: size.width / 3, delayTime: 1, dist: 500, angle: 15, damage: 0)
//            self.incomingFire(type: "gun", x: size.width / 2, delayTime: 1, dist: 700, angle: 0, damage: 0)
//            self.incomingFire(type: "laser", x: size.width / 1.2, delayTime: 1, dist: 1000, angle: 0, damage: 0)
//        }
//        
//        // Healthbar
//        playerHealthLabel.text = "Health: \(playerHealth)"
//        playerHealthLabel.fontName = "VT323-Regular"
//        playerHealthLabel.fontSize = 30
//        playerHealthLabel.fontColor = .yellow
//        playerHealthLabel.zPosition = 10
//        playerHealthLabel.position = CGPoint(x: size.width / 2, y: size.height / 1.3)
//        addChild(playerHealthLabel)
//        
//        // Ammobar
//        playerAmmoLabel.text = "Ammo: \(playerAmmo)"
//        playerAmmoLabel.fontName = "VT323-Regular"
//        playerAmmoLabel.fontSize = 30
//        playerAmmoLabel.fontColor = .yellow
//        playerAmmoLabel.zPosition = 10
//        playerAmmoLabel.position = CGPoint(x: size.width / 2, y: size.height / 1.3 - 40)
//        addChild(playerAmmoLabel)
//        
//        AmmoRegenTimer = .scheduledTimer(timeInterval: 3, target: self,
//                                         selector: #selector(addAmmo), userInfo: nil, repeats: true)
//        
//    }
//    
//    func didBegin(_ contact: SKPhysicsContact) {
//        let contactA : SKPhysicsBody
//        let contactB : SKPhysicsBody
//        
//        if contact.bodyA.categoryBitMask < contact.bodyB.categoryBitMask {
//            contactA = contact.bodyA
//            contactB = contact.bodyB
//        } else {
//            contactA = contact.bodyB
//            contactB = contact.bodyA
//        }
//        
//        // function if aircraft got hit
//        if contactA.categoryBitMask == CBitmask.playerAircraft && contactB.categoryBitMask == CBitmask.enemyFire {
//            // insert function here
//            playerGotHit(player: player, bullet: bulletGun)
//        }
//    }
//    
//    @objc func addAmmo(){
//        // Function to add Ammo until limit
//        if playerAmmo < 8 {
//            playerAmmo += 1
//            playerAmmoLabel.text = "Ammo: \(playerAmmo)"
//        }
//    }
//    
//    func playerGotHit(player: SKSpriteNode, bullet: SKSpriteNode){
//        // Decrement Health
//        playerHealth -= bulletDamage
//        playerHealthLabel.text = "Health: \(playerHealth)"
//        
//        // remove bullet
//        bulletGun.removeFromParent()
//        
//        // Check damage
//        if playerHealth <= 0 {
//            player.removeFromParent()
//            incomingGunTimer.invalidate()
//            gameOverFunc()
//            print("gameOver State: \(gameOver)")
//        }
//    }
//    
//    
//    override func update(_ currentTime: TimeInterval) {
//        // update plane position
//        super.update(currentTime)
//        
//        guard let accelData = motionManager.accelerometerData else {
//            return
//        }
//        
//        // Adjust aircraft movement based on gyroscope data
//        let movementFactor: CGFloat = 35.0
//        let dx = CGFloat(accelData.acceleration.x) * movementFactor
//        let dy = CGFloat(accelData.acceleration.y) * movementFactor
//        let newX = player.position.x + dx
//        let newY = player.position.y + dy
//        // Area restriction
////        print("x: \(newX) | y: \(newY)")
//        let constrainedX = min(maxX, max(minX, newX))
//        let constrainedY = min(maxY, max(minY, newY))
//        
//        player.position = CGPoint(x: constrainedX, y: constrainedY)
//
//    }
//    
//    func makeAircraft(style: Int) {
//        /*
//         Function to create aircraft object
//         */
//        var aircraftStyle = ""
//        
//        // pick aircraftstyle
//        switch style {
//        case 1:
//            aircraftStyle = "Aircraft 1"
//            
//        case 2:
//            aircraftStyle = "Aircraft 2"
//        
//        case 3:
//            aircraftStyle = "Aircraft 3"
//            
//        case 4:
//            aircraftStyle = "Aircraft 4"
//            
//        default:
//            aircraftStyle = "Aircraft 1"
//        }
//        
//        player = .init(imageNamed: aircraftStyle)
//        player.position =  CGPoint(
//            x: size.width / 2,
//            y: size.height / 2
//        )
//        player.zPosition = 20
//        player.setScale(1.6)
//        
//        // player's mechanics
//        player.physicsBody = SKPhysicsBody(rectangleOf: player.size)
//        player.physicsBody?.affectedByGravity = false
//        player.physicsBody?.isDynamic = true
//        player.physicsBody?.categoryBitMask = CBitmask.playerAircraft
//        player.physicsBody?.contactTestBitMask = CBitmask.enemyFire
//        player.physicsBody?.collisionBitMask = CBitmask.enemyFire
//        
//        addChild(player)
//    }
//    
//    func gameOverFunc() {
//        removeAllChildren()
//        addChild(background)
//        gameOver = true
//        
//        let gameOverLabel = SKLabelNode()
//        gameOverLabel.fontSize = 48
//        gameOverLabel.position = CGPoint(x: size.width / 2, y: size.height / 1.3 )
//        gameOverLabel.fontName = "VT323-Regular"
//        gameOverLabel.fontColor = .yellow
//        gameOverLabel.zPosition = 10
//        
//        if playerHealth <= 0 {
//            // Losing Condition
//            gameOverLabel.text = "You Lost!"
//        } else {
//            // Winning condition
//            gameOverLabel.text = "You Won!"
//        }
//        
//        addChild(gameOverLabel)
//    }
//    
//    func incomingFire(type: String , x: Double, delayTime: Double, dist: Double, angle: Double, damage: Double){
//        // new function for incoming fire for enemy enabled for multipeerconnectivity
//        
//        // Initial Position
//        enemyFire = .init(imageNamed: type)
//        enemyFire.position = CGPoint(x: x, y: size.height)
//        enemyFire.zPosition = 5
//        enemyFire.zRotation = angle * .pi / 180.0
//        
//        // bullet's physics
//        enemyFire.physicsBody = SKPhysicsBody(rectangleOf: enemyFire.size)
//        enemyFire.physicsBody?.affectedByGravity = false
//        enemyFire.physicsBody?.categoryBitMask = CBitmask.enemyFire
//        enemyFire.physicsBody?.contactTestBitMask = CBitmask.playerAircraft
//        enemyFire.physicsBody?.collisionBitMask = CBitmask.playerAircraft
//        
//        addChild(enemyFire)
//        
//        // Create animation
//        let target = CGPoint(
//            x: x + dist * sin(angle * .pi / 180),
//            y: size.height - dist)
//        let moveAction = SKAction.move(to: target, duration: delayTime)
//        let delateAction = SKAction.removeFromParent()
//        let combine = SKAction.sequence([moveAction, delateAction])
//        
//        enemyFire.run(combine)
//    }
//    
//    @objc func incomingGun(){
//        
//        // Tuning parameter
//        let delayTime = 1.0
//        let maxDist = 600.0
//        
//        // Initial position
//        bulletGun = .init(imageNamed: "gun")
//        bulletGun.position = CGPoint(x: size.width / 2, y: maxY)
//        bulletGun.zPosition = 5
//        
//        // bullet's physics
//        bulletGun.physicsBody = SKPhysicsBody(rectangleOf: bulletGun.size)
//        bulletGun.physicsBody?.affectedByGravity = false
//        bulletGun.physicsBody?.categoryBitMask = CBitmask.enemyFire
//        bulletGun.physicsBody?.contactTestBitMask = CBitmask.playerAircraft
//        bulletGun.physicsBody?.collisionBitMask = CBitmask.playerAircraft
//        
//        addChild(bulletGun)
//        
//        // Animation
//        let moveAction = SKAction.moveTo(y: maxDist, duration: delayTime)
//        let delateAction = SKAction.removeFromParent()
//        let combine = SKAction.sequence([moveAction, delateAction])
//        
//        bulletGun.run(combine)
//    }
//    
//    @objc func fireGun(){
//                
//        // Tuning parameter
//        let delayTime = 1.0
//        let maxDist = 1100.0
//        
//        // Initial position
//        bulletGun = .init(imageNamed: "gun")
//        bulletGun.position = player.position
//        bulletGun.zPosition = 3
//        
//        addChild(bulletGun)
//        
//        // Animation
//        let moveAction = SKAction.moveTo(y: maxDist, duration: delayTime)
//        let delateAction = SKAction.removeFromParent()
//        let combine = SKAction.sequence([moveAction, delateAction])
//        
//        bulletGun.run(combine)
//    }
//    
//    @objc func fireShell(){
//        // Tuning Parameter
//        let delayTime = 1.5
//        let maxDist = 900.0
//        let angle = 15.0
//        
//        // Initial position
//        bulletShellR = .init(imageNamed: "Shells")
//        bulletShellR.position = player.position
//        bulletShellR.zPosition = 3
//        bulletShellR.zRotation = -angle * .pi / 180.0
//        
//        bulletShellM = .init(imageNamed: "Shells")
//        bulletShellM.position = player.position
//        bulletShellM.zPosition = 3
//        bulletShellM.zRotation = 0 * .pi / 180.0
//
//        bulletShellL = .init(imageNamed: "Shells")
//        bulletShellL.position = player.position
//        bulletShellL.zPosition = 3
//        bulletShellL.zRotation = angle * .pi / 180.0
//        
//        addChild(bulletShellR)
//        addChild(bulletShellM)
//        addChild(bulletShellL)
//        
//        // Animation
//        let targetR = CGPoint(
//            x: player.position.x + maxDist * sin(angle * .pi / 180),
//            y: player.position.y + maxDist * cos(angle * .pi / 180))
//        let targetM = CGPoint(
//            x: player.position.x,
//            y: player.position.y + maxDist)
//        let targetL = CGPoint(
//            x: player.position.x + maxDist * sin(-angle * .pi / 180),
//            y: player.position.y + maxDist * cos(-angle * .pi / 180))
//        
//        let moveActionR = SKAction.move(to: targetR, duration: delayTime)
//        let moveActionM = SKAction.move(to: targetM, duration: delayTime)
//        let moveActionL = SKAction.move(to: targetL, duration: delayTime)
//        
//        let delateAction = SKAction.removeFromParent()
//        
//        let combineR = SKAction.sequence([moveActionR, delateAction])
//        let combineM = SKAction.sequence([moveActionM, delateAction])
//        let combineL = SKAction.sequence([moveActionL, delateAction])
//        
//        bulletShellR.run(combineR)
//        bulletShellM.run(combineM)
//        bulletShellL.run(combineL)
//    }
//}
//
//struct Gameplay: View {
//    @ObservedObject var scene = GameScene()
//    
//    var body: some View {
//        NavigationView {
//            HStack {
//                ZStack {
//                    SpriteView(scene: scene)
//                        .ignoresSafeArea()
//                    
//                    if scene.gameOver {
//                        // gameOver, back to result
//                        NavigationLink {
//                            MainScreen().navigationBarBackButtonHidden(true)
//                        } label: {
//                            Text("Main Menu")
//                        }
//                        .buttonStyle(RoundedButtonStyle())
//                        .padding(.top, 500)
//                    }
//                }
//            }
//        }
//    }
//}
//
////struct Gameplay_Previews: PreviewProvider {
////    static var previews: some View {
////        Gameplay()
////    }
////}
