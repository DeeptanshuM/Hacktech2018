//
//  ARViewController.swift
//  Hacktech2018
//
//  Created by Deetpanshu Malik on 3/4/18.
//  Copyright © 2018 Deeptanshu. All rights reserved.
//

// Relied on this appcoda tutorial, by Jayven N, to make this class: https://www.appcoda.com/arkit-horizontal-plane/
import UIKit
import ARKit

class ARViewController: UIViewController {

  var sceneName:String? = nil
  
  @IBOutlet weak var sceneView: ARSCNView!
  override func viewDidLoad() {
    super.viewDidLoad()
    addTapGestureToSceneView()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    setUpSceneView()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    super.viewWillDisappear(animated)
    sceneView.session.pause()
  }
  
  func setUpSceneView() {
    let configuration = ARWorldTrackingConfiguration()
    configuration.planeDetection = .horizontal
    sceneView.session.run(configuration)
    
    sceneView.delegate = self
    //sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
  }
  
  func configureLighting() {
    sceneView.autoenablesDefaultLighting = true
    sceneView.automaticallyUpdatesLighting = true
  }
  
  func addfoodToSceneViewWhenHorizontalPlaneDetected(x: CGFloat, y: CGFloat, z: CGFloat){
    let fileName = sceneName! + ".scn"
    //print(fileName)
    
    guard let foodScene = SCNScene(named: fileName),
      let foodNode = foodScene.rootNode.childNode(withName: "container", recursively: false)
      else { print("WTF");return }
    foodNode.position = SCNVector3(x,y,z)
    sceneView.scene.rootNode.addChildNode(foodNode)
  }
  @objc func addfoodToSceneView(withGestureRecognizer recognizer: UIGestureRecognizer) {
    let tapLocation = recognizer.location(in: sceneView)
    let hitTestResults = sceneView.hitTest(tapLocation, types: .existingPlaneUsingExtent)
    
    guard let hitTestResult = hitTestResults.first else { return }
    let translation = hitTestResult.worldTransform.translation
    let x = translation.x
    let y = translation.y
    let z = translation.z
    
    let fileName = sceneName! + ".scn"
    //print(fileName)

    guard let foodScene = SCNScene(named: fileName),
      let foodNode = foodScene.rootNode.childNode(withName: "container", recursively: false)
      else { print("WTF");return }
    foodNode.position = SCNVector3(x,y,z)
    sceneView.scene.rootNode.addChildNode(foodNode)
  }
  
  func addTapGestureToSceneView() {
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ARViewController.addfoodToSceneView(withGestureRecognizer:)))
    sceneView.addGestureRecognizer(tapGestureRecognizer)
  }
}
extension float4x4 {
  var translation: float3 {
    let translation = self.columns.3
    return float3(translation.x, translation.y, translation.z)
  }
}

extension UIColor {
  open class var transparentLightBlue: UIColor {
    return UIColor(red: 90/255, green: 200/255, blue: 250/255, alpha: 0.50)
  }
}

extension ARViewController: ARSCNViewDelegate {
  //  This protocol method gets called every time the scene view’s session has a new ARAnchor added. An ARAnchor is an object that represents a physical location and orientation in 3D space. We will use the ARAnchor later for detecting a horizontal plane
  func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
    guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
    
    let width = CGFloat(planeAnchor.extent.x)
    let height = CGFloat(planeAnchor.extent.z)
    let plane = SCNPlane(width: width, height: height)
    //let plane = SCNCylinder(radius: width, height: height);
    plane.materials.first?.diffuse.contents = UIColor.transparentLightBlue
    
    
    let planeNode = SCNNode(geometry: plane)
    let x = CGFloat(planeAnchor.center.x)
    let y = CGFloat(planeAnchor.center.y)
    let z = CGFloat(planeAnchor.center.z)
    planeNode.position = SCNVector3(x,y,z)
    planeNode.eulerAngles.x = -.pi / 2
    
    node.addChildNode(planeNode)
  }
  
  func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
    // 1
    guard let planeAnchor = anchor as?  ARPlaneAnchor,
      let planeNode = node.childNodes.first,
      let plane = planeNode.geometry as? SCNPlane
      else { return }
    
    // 2
    let width = CGFloat(planeAnchor.extent.x)
    let height = CGFloat(planeAnchor.extent.z)
    plane.width = width
    plane.height = height
    
    // 3
    let x = CGFloat(planeAnchor.center.x)
    let y = CGFloat(planeAnchor.center.y)
    let z = CGFloat(planeAnchor.center.z)
    planeNode.position = SCNVector3(x, y, z)
  }
}
