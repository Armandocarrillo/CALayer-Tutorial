
import UIKit

class CATextLayerViewController: UIViewController {
  @IBOutlet weak var viewForTextLayer: UIView!
  @IBOutlet weak var fontSizeSliderValueLabel: UILabel!
  @IBOutlet weak var fontSizeSlider: UISlider!
  @IBOutlet weak var wrapTextSwitch: UISwitch!
  @IBOutlet weak var alignmentModeSegmentedControl: UISegmentedControl!
  @IBOutlet weak var truncationModeSegmentedControl: UISegmentedControl!

  enum Font: Int {
    case helvetica, noteworthyLight
  }

  enum AlignmentMode: Int {
    case left, center, justified, right
  }
  enum TruncationMode: Int {
    case start, middle, end
  }

  private enum Constants {
    static let baseFontSize: CGFloat = 24.0
  }
  let noteworthyLightFont = CTFontCreateWithName("Noteworthy-Light" as CFString, Constants.baseFontSize, nil)
  let helveticaFont = CTFontCreateWithName("Helvetica" as CFString, Constants.baseFontSize, nil)
  let textLayer = CATextLayer()
  var previouslySelectedTruncationMode = TruncationMode.end

  override func viewDidLoad() {
    super.viewDidLoad()
    setUpTextLayer()
    viewForTextLayer.layer.addSublayer(textLayer)
  }

  override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    textLayer.frame = viewForTextLayer.bounds
  }
}

// MARK: - Layer setup
extension CATextLayerViewController {
  func setUpTextLayer() {
    textLayer.frame = viewForTextLayer.bounds

    let string = (1...20)
      .map { _ in
        "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Fusce auctor arcu quis velit congue dictum."
      }
      .joined(separator: " ")

    textLayer.string = string
    //set the font of the text layer
    textLayer.font = helveticaFont
    textLayer.fontSize = Constants.baseFontSize
    //set the options
    textLayer.foregroundColor = UIColor.darkGray.cgColor
    textLayer.isWrapped = true
    textLayer.alignmentMode = .left
    textLayer.truncationMode = .end
    //set contentsScale 
    textLayer.contentsScale = UIScreen.main.scale
  }

}

// MARK: - IBActions
extension CATextLayerViewController {
  @IBAction func fontSegmentedControlChanged(_ sender: UISegmentedControl) {
    switch sender.selectedSegmentIndex {
    case Font.helvetica.rawValue:
      textLayer.font = helveticaFont
    case Font.noteworthyLight.rawValue:
      textLayer.font = noteworthyLightFont
    default:
      break
    }
  }

  @IBAction func fontSizeSliderChanged(_ sender: UISlider) {
    fontSizeSliderValueLabel.text = "\(Int(sender.value * 100.0))%"
    textLayer.fontSize = Constants.baseFontSize * CGFloat(sender.value)
  }

  @IBAction func wrapTextSwitchChanged(_ sender: UISwitch) {
    alignmentModeSegmentedControl.selectedSegmentIndex = AlignmentMode.left.rawValue
    textLayer.alignmentMode = CATextLayerAlignmentMode.left

    if sender.isOn {
      if let truncationMode = TruncationMode(rawValue: truncationModeSegmentedControl.selectedSegmentIndex) {
        previouslySelectedTruncationMode = truncationMode
      }

      truncationModeSegmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
      textLayer.isWrapped = true
    } else {
      textLayer.isWrapped = false
      truncationModeSegmentedControl.selectedSegmentIndex = previouslySelectedTruncationMode.rawValue
    }
  }

  @IBAction func alignmentModeSegmentedControlChanged(_ sender: UISegmentedControl) {
    wrapTextSwitch.isOn = true
    textLayer.isWrapped = true
    truncationModeSegmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
    textLayer.truncationMode = CATextLayerTruncationMode.none

    switch sender.selectedSegmentIndex {
    case AlignmentMode.left.rawValue:
      textLayer.alignmentMode = .left
    case AlignmentMode.center.rawValue:
      textLayer.alignmentMode = .center
    case AlignmentMode.justified.rawValue:
      textLayer.alignmentMode = .justified
    case AlignmentMode.right.rawValue:
      textLayer.alignmentMode = .right
    default:
      textLayer.alignmentMode = .left
    }
  }

  @IBAction func truncationModeSegmentedControlChanged(_ sender: UISegmentedControl) {
    wrapTextSwitch.isOn = false
    textLayer.isWrapped = false
    alignmentModeSegmentedControl.selectedSegmentIndex = UISegmentedControl.noSegment
    textLayer.alignmentMode = .left

    switch sender.selectedSegmentIndex {
    case TruncationMode.start.rawValue:
      textLayer.truncationMode = .start
    case TruncationMode.middle.rawValue:
      textLayer.truncationMode = .middle
    case TruncationMode.end.rawValue:
      textLayer.truncationMode = .end
    default:
      textLayer.truncationMode = .none
    }
  }
}
