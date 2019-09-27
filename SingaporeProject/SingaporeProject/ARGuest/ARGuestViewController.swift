//
//  ARGuestViewController.swift
//  SingaporeProject
//
//  Created by 塗木冴 on 2019/09/27.
//  Copyright © 2019 塗木冴. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

import ARCore
import Firebase
import FirebaseDatabase
import RxSwift
import RxCocoa

class ARGuestViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    
    private lazy var firebaseReference = Database.database().reference().child("anchors")
    private var gSession: GARSession!
    //    private var fetchedAnchorIds: [String] = []
    private var viewModel = ARGuestViewModel()
    private let bag = DisposeBag()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureVM()
        configureAR()
        
        observeAnchors()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getEvents()
        let configuration = ARWorldTrackingConfiguration()
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        sceneView.session.pause()
    }
    
    // TODO: - AnchorをGoogle Cloud上に保存するとき、同時にAWS上にidentifierクーポンIDを連携させ、登録する
    //         ARNodeをタップした時に、クーポン情報を返せるようにする
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        guard let touch = touches.first else {
            return
        }
        let touchLocation = touch.location(in: sceneView)
        let hitTest  = sceneView.hitTest(touchLocation)
        if let result = hitTest.first  {
            guard let arAnchorID = result.node.name else { return }
            let event = viewModel.searchEvent(from: arAnchorID)
            let vc = ObtainBenefitViewController.create(with: event)
            vc.modalPresentationStyle = .custom
            vc.transitioningDelegate = self
            present(vc, animated: true, completion: {
                result.node.removeFromParentNode()
            })
        }
        else {
            resolveAnchor()
        }
    }
}

extension ARGuestViewController {
    
    private func configureVM() {
    }
    
    private func configureAR() {
        sceneView.delegate = self
        sceneView.session.delegate = self
        
        gSession = try! GARSession(apiKey: googleCloudAPIKey, bundleIdentifier: nil)
        gSession.delegate = self
        gSession.delegateQueue = DispatchQueue.main
    }
    
    // MEMO: - cloudIdentifierを受け取る
    private func observeAnchors() {
        firebaseReference.observe(.value) { (snapshot) in
            guard let value = snapshot.value as? [String : Any] else {
                return
            }
            let list = value.values
            print("observeAnchors--------------------\(list)-------------------------------------")
            list.forEach { value in
                if let dic = value as? [String: Any],
                    let arObject = ARObject(dictionary: dic) {
                    self.viewModel.addAnchor(with: arObject)
                }
            }
        }
    }
    
    // MEMO: - cloudIdentifierからGoogle Cloudを検索
    private func resolveAnchor(){
        viewModel.anchorIDs.value.forEach { cloudAnchorID in
            do {
                let newAnchor = try gSession.resolveCloudAnchor(withIdentifier: cloudAnchorID)
                viewModel.addNewAnchorID(with: String(describing: newAnchor.identifier), cloudAnchorID: cloudAnchorID)
            } catch {
                print(error)
            }
        }
        viewModel.anchorIDsTrigger.onNext([])
    }
    
    func generateSphereNode(by anchor: ARAnchor) -> SCNNode {
        let sphere = SCNSphere(radius: 0.05)
        let sphereNode = SCNNode()
        sphereNode.position.y += Float(sphere.radius)
        sphereNode.geometry = sphere
        sphereNode.name = anchor.name // MEMO: - AnchorIDをNodeの名前に設定し、検索に利用する
        return sphereNode
    }
}

// MARK: - ARSCNViewDelegate
extension ARGuestViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        if !(anchor is ARPlaneAnchor) {
            return generateSphereNode(by: anchor)
        }
        return nil
    }
}

// MARK: - ARSessionDelegate
extension ARGuestViewController: ARSessionDelegate {
    
    // MEMO: - ARCore が逐一空間を認識してGoogle Cloudと共有する
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        do {
            try gSession.update(frame)
        } catch {
            print("ARSessionDelegate didUpdate error: \(error)")
        }
    }
}

// MARK: - GARSessionDelegate
extension ARGuestViewController: GARSessionDelegate {
    
    func session(_ session: GARSession, didHostAnchor anchor: GARAnchor) {
        print("didHostAnchor")
    }
    
    func session(_ session: GARSession, didFailToHostAnchor anchor: GARAnchor) {
        print("didFailToHostAnchor")
    }
    
    // MEMO: - anchorの名前をidにすることで、タップした際にクーポンの情報を取得するKeyにする
    func session(_ session: GARSession, didResolve anchor: GARAnchor) {
        let arAnchor = ARAnchor(name: String(describing: anchor.identifier), transform: anchor.transform)
        sceneView.session.add(anchor: arAnchor)
    }
    
    func session(_ session: GARSession, didFailToResolve anchor: GARAnchor) {
        print("didFailToResolve")
    }
}


extension ARGuestViewController: UIViewControllerTransitioningDelegate {
    
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomPresentationController(presentedViewController: presented, presenting: presenting)
    }
}
