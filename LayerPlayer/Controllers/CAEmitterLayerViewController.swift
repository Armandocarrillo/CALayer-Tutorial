

import UIKit

class CAEmitterLayerViewController: UIViewController {
  @IBOutlet weak var viewForEmitterLayer: UIView!

  @objc var emitterLayer = CAEmitterLayer()
  @objc var emitterCell = CAEmitterCell()

  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    setUpEmitterCell()
    setUpEmitterLayer()
  }

  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   if segue.identifier == "DisplayEmitterControls" {
     (segue.destination as? CAEmitterLayerControlsViewController)?.emitterLayerViewController = self
   }
  }
}

// MARK: - Layer setup
extension CAEmitterLayerViewController {
  func setUpEmitterLayer() {
    
    //reset the layer
    resetEmitterCells()
    emitterLayer.frame = viewForEmitterLayer.bounds
    viewForEmitterLayer.layer.addSublayer(emitterLayer)
    // random number generator
    emitterLayer.seed = UInt32(Date().timeIntervalSince1970)
    //to set emitter position
    emitterLayer.emitterPosition = CGPoint(x: viewForEmitterLayer.bounds.midX * 1.5, y: viewForEmitterLayer.bounds.midY)
    
    emitterLayer.renderMode = .additive
    
  }

  func setUpEmitterCell() {
    //to set image that is available in the layer player
    emitterCell.contents = UIImage(named: "smallStar")?.cgImage
    // to set initial velocity
    emitterCell.velocity = 50.0
    emitterCell.velocityRange = 500.0
    
    emitterCell.color = UIColor.black.cgColor
    //select color ranges
    emitterCell.redRange = 1.0
    emitterCell.greenRange = 1.0
    emitterCell.blueRange = 1.0
    emitterCell.alphaRange = 0.0
    emitterCell.redSpeed = 0.0
    emitterCell.greenSpeed = 0.0
    emitterCell.blueSpeed = 0.0
    emitterCell.alphaSpeed = -0.5
    emitterCell.scaleSpeed = 0.1
    //
    let zeroDegreesInRadians = degreesToRadians(0.0)
    emitterCell.spin = degreesToRadians(130.0)
    emitterCell.spinRange = zeroDegreesInRadians
    emitterCell.emissionLatitude = zeroDegreesInRadians
    emitterCell.emissionLongitude = zeroDegreesInRadians
    emitterCell.emissionRange = degreesToRadians(360.0)
    //define the lifetime 1 second
    emitterCell.lifetime = 1.0
    emitterCell.birthRate = 250.0
    //affects the visual angle
    emitterCell.xAcceleration = -800
    emitterCell.yAcceleration = 1000
    
    
    
    
  }

  func resetEmitterCells() {
    emitterLayer.emitterCells = nil
    emitterLayer.emitterCells = [emitterCell]
  }
}

// MARK: - Triggered actions
extension CAEmitterLayerViewController {
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let location = touches.first?.location(in: viewForEmitterLayer) {
      emitterLayer.emitterPosition = location
    }
  }

  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    if let location = touches.first?.location(in: viewForEmitterLayer) {
      emitterLayer.emitterPosition = location
    }
  }
}
