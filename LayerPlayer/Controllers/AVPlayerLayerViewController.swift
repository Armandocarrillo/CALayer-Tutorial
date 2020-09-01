
import UIKit
import AVFoundation

class AVPlayerLayerViewController: UIViewController {
  @IBOutlet weak var viewForPlayerLayer: UIView!
  @IBOutlet weak var playButton: UIButton!
  @IBOutlet weak var rateSegmentedControl: UISegmentedControl!
  @IBOutlet weak var loopSwitch: UISwitch!
  @IBOutlet weak var volumeSlider: UISlider!

  enum Rate: Int {
    case slowForward, normal, fastForward
  }

  let playerLayer = AVPlayerLayer()
  var player: AVPlayer? {
    return playerLayer.player
  }
  var rate: Float {
    switch rateSegmentedControl.selectedSegmentIndex {
    case 0:
      return 0.5
    case 2:
      return 2.0
    default:
      return 1.0
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    rateSegmentedControl.selectedSegmentIndex = 1
    setUpPlayerLayer()
    viewForPlayerLayer.layer.addSublayer(playerLayer)
    NotificationCenter.default.addObserver(
      self,
      selector: #selector(AVPlayerLayerViewController.playerDidReachEndNotificationHandler(_:)),
      name: NSNotification.Name(rawValue: "AVPlayerItemDidPlayToEndTimeNotification"),
      object: player?.currentItem)
    playButton.setTitle("Pause", for: .normal)
  }
}

// MARK: - Layer setup
extension AVPlayerLayerViewController {
  func setUpPlayerLayer() {
    
    playerLayer.frame = viewForPlayerLayer.bounds
    
    let url = Bundle.main.url(forResource: "colorfulStreak", withExtension: "m4v")!
    let item = AVPlayerItem(asset: AVAsset(url: url))
    let player = AVPlayer(playerItem: item)
    
    player.actionAtItemEnd = .none
    
    player.volume = 1.0
    player.rate = 1.0
    
    playerLayer.player = player
  }
}

// MARK: - IBActions
extension AVPlayerLayerViewController {
  @IBAction func playButtonTapped(_ sender: UIButton) {
    if player?.rate == 0 {
      player?.rate = rate
      updatePlayButtonTitle(isPlaying: true)
    } else {
      player?.pause()
      updatePlayButtonTitle(isPlaying: false)
    }
  }

  @IBAction func rateSegmentedControlChanged(_ sender: UISegmentedControl) {
    player?.rate = rate
    updatePlayButtonTitle(isPlaying: true)
  }

  @IBAction func loopSwitchChanged(_ sender: UISwitch) {
    if sender.isOn {
      player?.actionAtItemEnd = .none
    } else {
      player?.actionAtItemEnd = .pause
    }
  }

  @IBAction func volumeSliderChanged(_ sender: UISlider) {
    player?.volume = sender.value
  }
}

// MARK: - Triggered actions
extension AVPlayerLayerViewController {
  @objc func playerDidReachEndNotificationHandler(_ notification: Notification) {
    //notification
    guard  let playerItem = notification.object as? AVPlayerItem else { return   }
  
    playerItem.seek(to: .zero, completionHandler: nil)
    
    if player?.actionAtItemEnd == .pause {
      player?.pause()
      updatePlayButtonTitle(isPlaying: false)
    }
  }
}

// MARK: - Helpers
extension AVPlayerLayerViewController {
  func updatePlayButtonTitle(isPlaying: Bool) {
    if isPlaying {
      playButton.setTitle("Pause", for: .normal)
    } else {
      playButton.setTitle("Play", for: .normal)
    }
  }
}
