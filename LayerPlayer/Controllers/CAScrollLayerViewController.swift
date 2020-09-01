

import UIKit

class CAScrollLayerViewController: UIViewController {
  @IBOutlet weak var scrollingView: ScrollingView!
  @IBOutlet weak var horizontalScrollingSwitch: UISwitch!
  @IBOutlet weak var verticalScrollingSwitch: UISwitch!

  var scrollingViewLayer: CAScrollLayer {
    // swiftlint:disable:next force_cast
    return scrollingView.layer as! CAScrollLayer
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    scrollingViewLayer.scrollMode = .both
  }
}

// MARK: - IBActions
extension CAScrollLayerViewController {
  //when a pan  gesture occurs, you calculate the translation
  @IBAction func panRecognized(_ sender: UIPanGestureRecognizer) {
    var newPoint = scrollingView.bounds.origin
    newPoint.x -= sender.translation(in: scrollingView).x
    newPoint.y -= sender.translation(in: scrollingView).y
    sender.setTranslation(.zero, in: scrollingView)
    scrollingViewLayer.scroll(to: newPoint)
    
    if sender.state == .ended {
      UIView.animate(withDuration: 0.3) {
        self.scrollingViewLayer.scroll(to: CGPoint.zero)
      }
    }
  }

  @IBAction func scrollingSwitchChanged(_ sender: UISwitch) {
    //determinate the scrolling direction according to the values
    
    switch (horizontalScrollingSwitch.isOn, verticalScrollingSwitch.isOn) {
    case (true,true):
      scrollingViewLayer.scrollMode = .both
    case (true,false):
      scrollingViewLayer.scrollMode = .horizontally
    case (false,true):
      scrollingViewLayer.scrollMode = .vertically
    default:
      scrollingViewLayer.scrollMode = .none
    }
  }
}
