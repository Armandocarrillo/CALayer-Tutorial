
import UIKit

class CALayerViewController: UIViewController {
  @IBOutlet weak var viewForLayer: UIView!

  let layer = CALayer()

  // MARK: - View life cycle
  override func viewDidLoad() {
    super.viewDidLoad()
    setUpLayer()
    viewForLayer.layer.addSublayer(layer)
  }

//this connects the embedded CALayerControlsViewController
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if segue.identifier == "DisplayLayerControls" {
      (segue.destination as? CALayerControlsViewController)?.layerViewController = self
    }
  }
}

// MARK: - Layer
extension CALayerViewController {
  func setUpLayer() {
    //set the bounds of the layer
    layer.frame = viewForLayer.bounds
    layer.contents = UIImage(named: "star")?.cgImage
    
    layer.contentsGravity = .center
    layer.magnificationFilter = .linear
    //set backgound
    layer.cornerRadius = 100.0
    layer.borderWidth = 12.0
    layer.borderColor = UIColor.white.cgColor
    layer.backgroundColor = swiftOrangeColor.cgColor
    
    //set shadow
    layer.shadowOpacity = 0.75
    layer.shadowOffset = CGSize(width: 0, height: 3)
    layer.shadowRadius = 3.0
    layer.isGeometryFlipped = false
  }
}
