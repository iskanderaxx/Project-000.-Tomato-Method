
import UIKit
import SnapKit

final class ViewController: UIViewController {
    
    // MARK: - States & Introductory data
    
    private var tomatoTimer = Timer()
    private var isWorkTime = true
    private var isStarted = false
    private var timeLoop = 25
    private var tomatoTime = 25
    private var pauseTime = 5
    
    // MARK: - UIElements & Oulets
    
    private lazy var backgroundImage: UIImageView = {
        let image = UIImage(named: "backgroundImage")
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFill
        imageView.isOpaque = false
        imageView.alpha = 0.8
        return imageView
    }()
    
    private lazy var stageLabel: UILabel = {
        let label = UILabel()
        label.text = "Tomato time"
        label.textColor = .systemRed
        label.font = UIFont.boldSystemFont(ofSize: 30)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var timerLabel: UILabel = {
        let label = UILabel()
        label.text = "00:25"
        label.textColor = .white
        label.font = UIFont.boldSystemFont(ofSize: 45)
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()
    
    private lazy var startOrPauseButton: UIButton = {
        let button = UIButton(type: .system)
        button.clipsToBounds = true
        button.backgroundColor = .clear
        button.addTarget(self, action: #selector(startOrPauseButtonPressed), for: .touchUpInside)
        button.setImage(UIImage(named: "icons8-play"), for: .normal)
        button.tintColor = .white
        return button
    }()
    
    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.distribution = .equalSpacing
        return stackView
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black
        setupHierarchy()
        setupStackView()
        setupLayout()
    }
    
    // MARK: - Setup
    
    private func setupHierarchy() {
        [backgroundImage, stackView].forEach {
            view.addSubview($0)
        }
    }
    
    private func setupStackView() {
        [stageLabel, timerLabel, startOrPauseButton].forEach {
            stackView.addArrangedSubview($0)
        }
    }
    
    private func setupLayout() {
        backgroundImage.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.centerY.equalTo(view)
        }
        
        stackView.snp.makeConstraints { make in
            make.centerX.equalTo(view)
            make.bottom.equalToSuperview().offset(-175)
            make.top.equalToSuperview().offset(100)
        }
    }
    
    // MARK: - Actions
    
    @objc
    private func startOrPauseButtonPressed() {
        if !isStarted {
            startTimer()
            startOrPauseButton.setImage(UIImage(named: "icons8-pause"), for: .normal)
            isStarted = true
        } else {
            tomatoTimer.invalidate()
            startOrPauseButton.setImage(UIImage(named: "icons8-play"), for: .normal)
            isStarted = false
        }
    }
    
    @objc
    private func startTimer() {
        tomatoTimer = Timer.scheduledTimer(
            timeInterval: 1.0,
            target: self,
            selector: #selector(fireTimer),
            userInfo: nil,
            repeats: true
        )
    }
    
    @objc
    private func fireTimer() {
        if timeLoop > 1 {
            timeLoop -= 1
            timerLabel.text = timeString()
            print(timeLoop)
        } else {
            stageLabel.text = isWorkTime ? "Rest time" : "Tomato time"
            stageLabel.textColor = isWorkTime ? .systemGreen : .systemRed
            tomatoTimer.invalidate()
            startOrPauseButton.setImage(UIImage(named: "icons8-play"), for: .normal)
            isWorkTime = !isWorkTime
            timeLoop = isWorkTime ? tomatoTime : pauseTime
            isStarted = false
            timerLabel.text = timeString()
        }
    }
    
    private func timeString() -> String {
        let minutes = Int(timeLoop) / 60 % 60
        let seconds = Int(timeLoop) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
}

