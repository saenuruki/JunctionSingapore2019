//
//  ARAdminViewController.swift
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
import FloatingPanel

class ARAdminViewController: UIViewController {
    
    @IBOutlet var sceneView: ARSCNView!
    
    private lazy var firebaseReference = Database.database().reference().child("anchors")
    private var gSession: GARSession!
    private var viewModel = ARAdminViewModel()
    private var fetchedAnchorIds: [String] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAR()
        configureFroatingPanel()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        viewModel.getEvents()
        
        let configuration = ARWorldTrackingConfiguration()
        configuration.planeDetection = .horizontal
        configuration.worldAlignment = .gravity
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
        let hitTestResults = sceneView.hitTest(touchLocation, types: [.existingPlane, .existingPlaneUsingExtent, .estimatedHorizontalPlane])
        
        if let result = hitTestResults.first {
            addAnchor(transform: result.worldTransform)
        }
    }
}

// MARK: - Some Original Method
extension ARAdminViewController {
    
    private func configureAR() {
        sceneView.delegate = self
        sceneView.session.delegate = self
        
        gSession = try! GARSession(apiKey: googleCloudAPIKey, bundleIdentifier: nil)
        gSession.delegate = self
        gSession.delegateQueue = DispatchQueue.main
    }
    
    private func configureFroatingPanel() {
        let fpController = FloatingPanelController()
        fpController.delegate = self
        fpController.surfaceView.backgroundColor = .white
        fpController.surfaceView.cornerRadius = 24.0
        fpController.surfaceView.shadowHidden = true
        fpController.surfaceView.borderWidth = 1.0 / traitCollection.displayScale
        fpController.surfaceView.borderColor = UIColor.black.withAlphaComponent(0.2)
        
        let floatingVC = PickerFloatingPanelViewController.create(viewModel)
        fpController.set(contentViewController: floatingVC)
        fpController.addPanel(toParent: self, belowView: nil, animated: false)
    }
    
    // addAnchor to AR Space and share the anchor data to Google Cloud
    private func addAnchor(transform: matrix_float4x4) {
        let arAnchor = ARAnchor(transform: transform)
        sceneView.session.add(anchor: arAnchor)
        viewModel.putSelectedEvent()
        do {
            // MEMO: - Google CloudにAnchorを共有する
            _ = try gSession.hostCloudAnchor(arAnchor)
        } catch {
            print(error)
        }
    }
    
    func generateSphereNode() -> SCNNode {
        
        let cube = SCNBox(width: 0.1, height: 0.1, length: 0.1, chamferRadius: 0)
        let cubeNode = SCNNode(geometry: cube)
        cubeNode.name = "red"
        
        // Cubeのマテリアルを設定
        let material = SCNMaterial()
        material.diffuse.contents = UIColor.red
        material.diffuse.intensity = 0.8;
        cubeNode.geometry?.materials = [material]
        
        return cubeNode
    }
}

// MARK: - ARSCNViewDelegate
extension ARAdminViewController: ARSCNViewDelegate {
    
    func renderer(_ renderer: SCNSceneRenderer, nodeFor anchor: ARAnchor) -> SCNNode? {
        if !(anchor is ARPlaneAnchor) {
            return generateSphereNode()
        }
        return nil
    }
}

// MARK: - ARSCNViewDelegate
extension ARAdminViewController: ARSessionDelegate {
    
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        do {
            try gSession.update(frame)
        } catch {
            print(error)
        }
    }
}

// MARK: - GARSessionDelegate
extension ARAdminViewController: GARSessionDelegate {
    
    // MEMO: - Google CloudにAnchorの登録が完了すると呼ばれる
    func session(_ session: GARSession, didHostAnchor anchor: GARAnchor) {
        print("didHostAnchor")
        guard let cloudAnchorID = anchor.cloudIdentifier else { return }
        let event = viewModel.getSelectedEvent()
        firebaseReference.childByAutoId().setValue(["cloud_anchor_id": cloudAnchorID, "event_id": event.id])
    }
    
    // MEMO: - Google CloudにAnchorの登録に失敗すると呼ばれる
    func session(_ session: GARSession, didFailToHostAnchor anchor: GARAnchor) {
        print("didFailToHostAnchor")
    }
    
    func session(_ session: GARSession, didResolve anchor: GARAnchor) {
        print("didResolve")
        let arAnchor = ARAnchor(transform: anchor.transform)
        sceneView.session.add(anchor: arAnchor)
    }
    
    func session(_ session: GARSession, didFailToResolve anchor: GARAnchor) {
        print("didFailToResolve")
    }
}

// MARK: - FloatingPanelControllerDelegate
extension ARAdminViewController: FloatingPanelControllerDelegate {
    
    func floatingPanel(_ vc: FloatingPanelController, layoutFor newCollection: UITraitCollection) -> FloatingPanelLayout? {
        return FloatingPanelStocksLayout()
    }
    
    func floatingPanel(_ vc: FloatingPanelController, behaviorFor newCollection: UITraitCollection) -> FloatingPanelBehavior? {
        return FloatingPanelStocksBehavior()
    }
    
    func floatingPanelWillBeginDragging(_ vc: FloatingPanelController) {
    }
    func floatingPanelDidEndDragging(_ vc: FloatingPanelController, withVelocity velocity: CGPoint, targetPosition: FloatingPanelPosition) {
    }
}

