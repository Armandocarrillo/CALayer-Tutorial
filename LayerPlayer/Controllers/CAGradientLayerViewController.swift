

import UIKit

class CAGradientLayerViewController: UIViewController {
  @IBOutlet weak var viewForGradientLayer: UIView!
  @IBOutlet weak var startPointSlider: UISlider!
  @IBOutlet weak var startPointSliderValueLabel: UILabel!
  @IBOutlet weak var endPointSlider: UISlider!
  @IBOutlet weak var endPointSliderValueLabel: UILabel!
  @IBOutlet var colorSwitches: [UISwitch]!
  @IBOutlet var locationSliders: [UISlider]!
  @IBOutlet var locationSliderValueLabels: [UILabel]!

  let gradientLayer = CAGradientLayer()
  let colors: [CGColor] = [
    UIColor(red: 209, green: 0, blue: 0),
    UIColor(red: 255, green: 102, blue: 34),
    UIColor(red: 255, green: 218, blue: 33),
    UIColor(red: 51, green: 221, blue: 0),
    UIColor(red: 17, green: 51, blue: 204),
    UIColor(red: 34, green: 0, blue: 102),
    UIColor(red: 51, green: 0, blue: 68)
  ].map { $0.cgColor }

  let locations: [Float] = [0, 1 / 6.0, 1 / 3.0, 0.5, 2 / 3.0, 5 / 6.0, 1.0]

  override func viewDidLoad() {
    super.viewDidLoad()
    sortOutletCollections()
    setUpGradientLayer()
    viewForGradientLayer.layer.addSublayer(gradientLayer)
    setUpLocationSliders()
    updateLocationSliderValueLabels()
  }
}

// MARK: - Setup layer
extension CAGradientLayerViewController {
  func sortOutletCollections() {
    colorSwitches.sortUIViewsInPlaceByTag()
    locationSliders.sortUIViewsInPlaceByTag()
    locationSliderValueLabels.sortUIViewsInPlaceByTag()
  }

  func setUpGradientLayer() {
    
    gradientLayer.frame = viewForGradientLayer.bounds
    gradientLayer.colors = colors
    gradientLayer.locations = locations.map { NSNumber(value: $0)}
    gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
    gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)
    
  }

  func setUpLocationSliders() {
    guard let sliders = locationSliders else {
      return
    }

    for (index, slider) in sliders.enumerated() {
      slider.value = locations[index]
    }
  }
}

// MARK: - @IBActions
extension CAGradientLayerViewController {
  @IBAction func startPointSliderChanged(_ sender: UISlider) {
    gradientLayer.startPoint = CGPoint(x: CGFloat(sender.value), y: 0.0)
    updateStartAndEndPointValueLabels()
  }

  @IBAction func endPointSliderChanged(_ sender: UISlider) {
    gradientLayer.endPoint = CGPoint(x: CGFloat(sender.value), y: 1.0)
    updateStartAndEndPointValueLabels()
  }

  @IBAction func colorSwitchChanged(_ sender: UISwitch) {
    var gradientLayerColors: [AnyObject] = []
    var locations: [NSNumber] = []

    for (index, colorSwitch) in colorSwitches.enumerated() {
      let slider = locationSliders[index]

      if colorSwitch.isOn {
        gradientLayerColors.append(colors[index])
        locations.append(NSNumber(value: slider.value as Float))
        slider.isEnabled = true
      } else {
        slider.isEnabled = false
      }
    }

    if gradientLayerColors.count == 1 {
      gradientLayerColors.append(gradientLayerColors[0])
    }

    gradientLayer.colors = gradientLayerColors
    gradientLayer.locations = locations.count > 1 ? locations : nil
    updateLocationSliderValueLabels()
  }

  @IBAction func locationSliderChanged(_ sender: UISlider) {
    var gradientLayerLocations: [NSNumber] = []

    for (index, slider) in locationSliders.enumerated() {
      let colorSwitch = colorSwitches[index]

      if colorSwitch.isOn {
        gradientLayerLocations.append(NSNumber(value: slider.value as Float))
      }
    }

    gradientLayer.locations = gradientLayerLocations
    updateLocationSliderValueLabels()
  }
}

// MARK: - Triggered actions
extension CAGradientLayerViewController {
  func updateStartAndEndPointValueLabels() {
    startPointSliderValueLabel.text = String(format: "(%.1f, 0.0)", startPointSlider.value)
    endPointSliderValueLabel.text = String(format: "(%.1f, 1.0)", endPointSlider.value)
  }

  func updateLocationSliderValueLabels() {
    for (index, label) in locationSliderValueLabels.enumerated() {
      let colorSwitch = colorSwitches[index]

      if colorSwitch.isOn {
        let slider = locationSliders[index]
        label.text = String(format: "%.2f", slider.value)
        label.isEnabled = true
      } else {
        label.isEnabled = false
      }
    }
  }
}

// MARK: - Helpers
private extension UIColor {
  convenience init(red: Int, green: Int, blue: Int) {
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: 1)
  }
}
