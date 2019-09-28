//
//  GamePlayerViewController.swift
//  SingaporeProject
//
//  Created by 塗木冴 on 2019/09/28.
//  Copyright © 2019 塗木冴. All rights reserved.
//

import UIKit
import ARKit

class GamePlayerViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    @IBOutlet weak var hitLabel: UILabel!
//        {
//        didSet {
//            hitLabel.isHidden = true
//        }
//    }
    fileprivate private(set) weak var viewModel: GameViewModel!

    
    var second: Double = 30.0
    var timer = Timer()
    
    let defaultConfiguration: ARWorldTrackingConfiguration = {
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        return configuration
    }()
    
    lazy var boxNode: SCNNode = {
//        let cylinder = SCNCylinder(radius: 0.1, height: 0.05)
//        let box = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0.01)
//        box.firstMaterial?.diffuse.contents = UIColor.red
//        let node = SCNNode(geometry: box)
//        node.name = "box"
//        node.position = SCNVector3Make(0, 0, -1.5)
//
//        // add PhysicsShape
//        let shape = SCNPhysicsShape(geometry: box, options: nil)
//        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
//        node.physicsBody?.isAffectedByGravity = false
//
//        return node
//        let scene = SCNScene(named: "art.scnassets/pictureTable.scn")!
//        let node = scene.rootNode.childNode(withName: "tableNode", recursively: false)!
//        let box = SCNBox(width: 0.3, height: 0.3, length: 0.1, chamferRadius: 0.01)
//        let node = SCNNode(geometry: box)
//        node.name = "box"
////        node.position = SCNVector3Make(0, 0, -1.5)
//
//        // 写真のnode
//        let picture = SCNBox(width: 0.3, height: 0.3, length: 0.01, chamferRadius: 0)
////        picture.firstMaterial?.diffuse.contents = self.viewModel.getImage(by: self.viewModel.itemType.value)
//        picture.firstMaterial?.diffuse.contents = R.image.img_macbook()
//        let pictureNode = SCNNode(geometry: picture)
//
//        // frameに貼る
//        let frameNode = node.childNode(withName: "frame", recursively: true)
//        frameNode?.addChildNode(pictureNode)
//
//        node.scale = SCNVector3(x: 0.3, y: 0.3, z: 0.3)
//        return node
        
        let cube = SCNBox(width: 0.3, height: 0.3, length: 0.01, chamferRadius: 0)
        let cubeNode = SCNNode(geometry: cube)
        cubeNode.name = "box"
        
        // 6面、別々のテクスチャを貼る
        let m1 = SCNMaterial()
//        let m2 = SCNMaterial()
//        let m3 = SCNMaterial()
//        let m4 = SCNMaterial()
//        let m5 = SCNMaterial()
//        let m6 = SCNMaterial()
        
        m1.diffuse.contents = R.image.img_macbook()
//        m2.diffuse.contents = R.image.img_macbook()
//        m3.diffuse.contents = R.image.img_macbook()
//        m4.diffuse.contents = R.image.img_macbook()
//        m5.diffuse.contents = R.image.img_macbook()
//        m6.diffuse.contents = R.image.img_macbook()
//
//        cube.materials = [m1, m2, m3, m4, m5, m6]
        cube.firstMaterial = m1
        
        // 初期位置の指定: 50cm画面奥、10cm上方に配置
        cubeNode.position = SCNVector3Make(0, 0, -1.5)
        
        return cubeNode
        
    }()
    
    static func create(viewModel: GameViewModel) -> UIViewController {
        let vc = R.storyboard.gamePlayer.instantiateInitialViewController()!
        vc.viewModel = viewModel
        return vc
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        sceneView.autoenablesDefaultLighting = true
        sceneView.scene.physicsWorld.contactDelegate = self
        
        sceneView.scene.rootNode.addChildNode(boxNode)
        
        runTimer()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        sceneView.session.run(defaultConfiguration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let ball = SCNSphere(radius: 0.1)
        ball.firstMaterial?.diffuse.contents = UIColor.blue
        
        let node = SCNNode(geometry: ball)
        node.name = "ball"
        node.position = SCNVector3Make(0, 0.1, 0)
        
        // add PhysicsShape
        let shape = SCNPhysicsShape(geometry: ball, options: nil)
        node.physicsBody = SCNPhysicsBody(type: .dynamic, shape: shape)
        node.physicsBody?.contactTestBitMask = 1
        node.physicsBody?.isAffectedByGravity = false
        
        if let camera = sceneView.pointOfView {
            node.position = camera.position
            
            let toPositionCamera = SCNVector3Make(0, 0, -3)
            let toPosition = camera.convertPosition(toPositionCamera, to: nil)
            
            let move = SCNAction.move(to: toPosition, duration: 0.5)
            move.timingMode = .easeOut
            node.runAction(move) {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    node.removeFromParentNode()
                }
            }
        }
        sceneView.scene.rootNode.addChildNode(node)
    }
    
}

extension GamePlayerViewController: SCNPhysicsContactDelegate {
    func physicsWorld(_ world: SCNPhysicsWorld, didBegin contact: SCNPhysicsContact) {
        let nodeA = contact.nodeA
        let nodeB = contact.nodeB
        
        if (nodeA.name == "box" && nodeB.name == "ball")
            || (nodeB.name == "box" && nodeA.name == "ball") {
            
            DispatchQueue.main.async {
//                self.hitLabel.text = "HIT!!"
//                self.hitLabel.sizeToFit()
//                self.hitLabel.isHidden = false
//
//                // Vibration
                AudioServicesPlaySystemSound(kSystemSoundID_Vibrate)
//
//                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//                    self.hitLabel.isHidden = true
//                }
                self.viewModel.addGameScore()
            }
        }
    }
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: (#selector(GamePlayerViewController.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        second -= 0.1
        hitLabel.text = String(describing: round(second*10)/10)
        if second < 0 {
            self.dismiss(animated: false, completion: {
                // 親のViewControllerも閉じるためのフラグを立てる
                self.viewModel.dismissFlagTrigger.onNext(true)
            })
        }
    }
}
