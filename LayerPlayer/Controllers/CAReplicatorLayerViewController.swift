

import UIKit

class CAReplicatorLayerViewController: UIViewController {
  @IBOutlet weak var viewForReplicatorLayer: UIView!
  @IBOutlet weak var layerSizeSlider: UISlider!
  @IBOutlet weak var layerSizeSliderValueLabel: UILabel!
  @IBOutlet weak var instanceCountSlider: UISlider!
  @IBOutlet weak var instanceCountSliderValueLabel: UILabel!
  @IBOutlet weak var instanceDelaySlider: UISlider!
  @IBOutlet weak var instanceDelaySliderValueLabel: UILabel!
  @IBOutlet weak var offsetRedSwitch: UISwitch!
  @IBOutlet weak var offsetGreenSwitch: UISwitch!
  @IBOutlet weak var offsetBlueSwitch: UISwitch!
  @IBOutlet weak var offsetAlphaSwitch: UISwitch!

  let lengthMultiplier: CGFloat = 3.0
  let replicatorLayer = CAReplicatorLayer()
  let instanceLayer = CALayer()
  let fadeAnimation = CABasicAnimation(keyPath: "opacity")

  override func viewDidLoad() {
    super.viewDidLoad()
    setUpReplicatorLayer()
    setUpInstanceLayer()
    setUpLayerFadeAnimation()
    instanceDelaySliderChanged(instanceDelaySlider)
    updateLayerSizeSliderValueLabel()
    updateInstanceCountSliderValueLabel()
    updateInstanceDelaySliderValueLabel()
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    setUpReplicatorLayer()
    setUpInstanceLayer()
  }
}

// MARK: - Layer setup
extension CAReplicatorLayerViewController {
  func setUpReplicatorLayer() {
    
    replicatorLayer.frame = viewForReplicatorLayer.bounds
    //to set the number of replications
    let count = instanceCountSlider.value
    replicatorLayer.instanceCount = Int(count)
    replicatorLayer.instanceDelay = CFTimeInterval(instanceCountSlider.value / count )
    //to define the base color for all replicated instance
    replicatorLayer.instanceColor = UIColor.white.cgColor
    replicatorLayer.instanceRedOffset = offsetValueForSwitch(offsetRedSwitch)
    replicatorLayer.instanceGreenOffset = offsetValueForSwitch(offsetGreenSwitch)
    replicatorLayer.instanceBlueOffset = offsetValueForSwitch(offsetBlueSwitch)
    replicatorLayer.instanceAlphaOffset = offsetValueForSwitch(offsetAlphaSwitch)
    //to rotate instance "circle effect"
    let angle = Float.pi * 2.0 / count
    replicatorLayer.instanceTransform = CATransform3DMakeRotation(CGFloat(angle), 0.0, 0.0, 1.0)
    //to add layer to the view s layer
    viewForReplicatorLayer.layer.addSublayer(replicatorLayer)
  }

  func setUpInstanceLayer() {
    //sets the instance frame
    let layerWidth = CGFloat(layerSizeSlider.value)
    let midX = viewForReplicatorLayer.bounds.midX - layerWidth / 2.0
    instanceLayer.frame = CGRect(
      x: midX,
      y: 0.0,
      width: layerWidth,
      height: layerWidth * lengthMultiplier )
    instanceLayer.backgroundColor = UIColor.white.cgColor
    replicatorLayer.addSublayer(instanceLayer)
    
  }

  func setUpLayerFadeAnimation() {
    
    //fade animation
    fadeAnimation.fromValue = 1.0
    fadeAnimation.toValue = 0.0
    fadeAnimation.repeatCount = Float(Int.max)
  }
}

// MARK: - IBActions
extension CAReplicatorLayerViewController {
  @IBAction func layerSizeSliderChanged(_ sender: UISlider) {
    let value = CGFloat(sender.value)
    instanceLayer.bounds = CGRect(origin: .zero, size: CGSize(width: value, height: value * lengthMultiplier))
    updateLayerSizeSliderValueLabel()
  }

  @IBAction func instanceCountSliderChanged(_ sender: UISlider) {
    replicatorLayer.instanceCount = Int(sender.value)
    replicatorLayer.instanceAlphaOffset = offsetValueForSwitch(offsetAlphaSwitch)
    updateInstanceCountSliderValueLabel()
  }

  @IBAction func instanceDelaySliderChanged(_ sender: UISlider) {
    if sender.value > 0.0 {
      replicatorLayer.instanceDelay = CFTimeInterval(sender.value / Float(replicatorLayer.instanceCount))
      setLayerFadeAnimation()
    } else {
      replicatorLayer.instanceDelay = 0.0
      instanceLayer.opacity = 1.0
      instanceLayer.removeAllAnimations()
    }

    updateInstanceDelaySliderValueLabel()
  }

  @IBAction func offsetSwitchChanged(_ sender: UISwitch) {
    switch sender {
    case offsetRedSwitch:
      replicatorLayer.instanceRedOffset = offsetValueForSwitch(sender)
    case offsetGreenSwitch:
      replicatorLayer.instanceGreenOffset = offsetValueForSwitch(sender)
    case offsetBlueSwitch:
      replicatorLayer.instanceBlueOffset = offsetValueForSwitch(sender)
    case offsetAlphaSwitch:
      replicatorLayer.instanceAlphaOffset = offsetValueForSwitch(sender)
    default:
      break
    }
  }
}

// MARK: - Triggered actions
extension CAReplicatorLayerViewController {
  func setLayerFadeAnimation() {
    instanceLayer.opacity = 0.0
    fadeAnimation.duration = CFTimeInterval(instanceDelaySlider.value)
    instanceLayer.add(fadeAnimation, forKey: "FadeAnimation")
  }
}

// MARK: - Helpers
extension CAReplicatorLayerViewController {
  func offsetValueForSwitch(_ offsetSwitch: UISwitch) -> Float {
    if offsetSwitch == offsetAlphaSwitch {
      let count = Float(replicatorLayer.instanceCount)
      return offsetSwitch.isOn ? -1.0 / count : 0.0
    } else {
      return offsetSwitch.isOn ? 0.0 : -0.05
    }
  }

  func updateLayerSizeSliderValueLabel() {
    let value = layerSizeSlider.value
    layerSizeSliderValueLabel.text = String(format: "%.0f x %.0f", value, value * Float(lengthMultiplier))
  }

  func updateInstanceCountSliderValueLabel() {
    instanceCountSliderValueLabel.text = String(format: "%.0f", instanceCountSlider.value)
  }

  func updateInstanceDelaySliderValueLabel() {
    instanceDelaySliderValueLabel.text = String(format: "%.0f", instanceDelaySlider.value)
  }
}
