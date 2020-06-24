//
//  MikeButton.swift
//  SCTranslation
//
//  Created by 천지운 on 2020/06/22.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import UIKit
import Speech

protocol MikeButtonViewDelegate: class {
  func finishRecorder(_ voiceText: String)
}

class MikeButtonView: UIView {
  
  // MARK: - Properties
  
  weak var delegate: MikeButtonViewDelegate?
  
  private var recordText: String?
  var configureLanguage: Language? = dataLanguages[0]
  
  private var speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "ko-KR"))
  private var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
  private var recognitionTask: SFSpeechRecognitionTask?
  private let audioEngine = AVAudioEngine()
  
  var animateTimer: Timer?
  
  var isRecording: Bool = false {
    didSet {
      let micSymbolImage = UIImage(systemName: "mic", withConfiguration: configuration)
      let stopSymbolImage = UIImage(systemName: "stop", withConfiguration: configuration)
      if isRecording {
        mikeButton.setImage(stopSymbolImage, for: .normal)
        mikeButton.backgroundColor = .white
        mikeButton.tintColor = .systemPurple
      }
      else {
        mikeButton.setImage(micSymbolImage, for: .normal)
        mikeButton.backgroundColor = .clear
        mikeButton.tintColor = .white
      }
    }
  }
  
  let configuration = UIImage.SymbolConfiguration(pointSize: 25, weight: .medium, scale: .large)
  lazy var mikeButton: UIButton = {
    let button = UIButton(type: .system)
    
    let micSymbolImage = UIImage(systemName: "mic", withConfiguration: configuration)
    button.setImage(micSymbolImage, for: .normal)
    
    button.tintColor = .white
    button.backgroundColor = .clear
    button.clipsToBounds = true
    button.addTarget(self, action: #selector(handleRecorder(_:)), for: .touchUpInside)
    return button
  }()
  
  // MARK: - LifeCycle
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    configureUI()
  }
  
  required init?(coder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  // MARK: - Helpers
  
  func configureUI() {
    
    let buttonSize: CGFloat = 80
    
    layer.borderColor = UIColor.black.cgColor
    layer.borderWidth = 0.5
    layer.cornerRadius = buttonSize / 2

    layer.shadowColor = UIColor.black.cgColor
    layer.shadowOffset = CGSize(width: 0, height: 0)
    layer.shadowRadius = 2
    layer.shadowOpacity = 1.0
    
    clipsToBounds = true
    
    translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      widthAnchor.constraint(equalToConstant: buttonSize),
      heightAnchor.constraint(equalToConstant: buttonSize)
    ])
    
    addSubview(mikeButton)
    mikeButton.translatesAutoresizingMaskIntoConstraints = false
    NSLayoutConstraint.activate([
      mikeButton.topAnchor.constraint(equalTo: topAnchor),
      mikeButton.leadingAnchor.constraint(equalTo: leadingAnchor),
      mikeButton.trailingAnchor.constraint(equalTo: trailingAnchor),
      mikeButton.bottomAnchor.constraint(equalTo: bottomAnchor)
    ])
  }
  
  func startRecording() {
    if recognitionTask != nil {
      recognitionTask?.cancel()
      recognitionTask = nil
    }
    guard let language = configureLanguage else { return }
    speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: language.transVoice))
    
    let audioSession = AVAudioSession.sharedInstance()
    do {
      try audioSession.setCategory(AVAudioSession.Category.record)
      try audioSession.setMode(AVAudioSession.Mode.measurement)
      try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
    } catch {
      print("audioSession properties weren't set because of an error.")
    }
    
    recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
    
    let inputNode = audioEngine.inputNode
    
    guard let recognitionRequest = recognitionRequest else {
      fatalError("Unable to create an SFSpeechAudioBufferRecognitionRequest object")
    }
    
    recognitionRequest.shouldReportPartialResults = true
    
    recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest, resultHandler: { (result, error) in
      
      var isFinal = false
      
      if result != nil {
        self.recordText = result?.bestTranscription.formattedString
        
        if let text = self.recordText {
          self.delegate?.finishRecorder(text)
        }
        
        isFinal = (result?.isFinal)!
      }
      
      if error != nil || isFinal {
        self.audioEngine.stop()
        inputNode.removeTap(onBus: 0)
        
        self.recognitionRequest = nil
        self.recognitionTask = nil
      }
    })
    
    let recordingFormat = inputNode.outputFormat(forBus: 0)
    inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, when) in
      self.recognitionRequest?.append(buffer)
    }
    
    audioEngine.prepare()
    
    do {
      try audioEngine.start()
    } catch {
      print("audioEngine couldn't start because of an error.")
    }
    print("Say something, I'm listening!")
    
  }
  
  // MARK: - Selecters
  
  @objc func handleRecorder(_ sender: UIButton) {
    isRecording.toggle()
    
    if isRecording {
      animateTimer = Timer.scheduledTimer(
        timeInterval: 0.5,
        target: self,
        selector: #selector(handleAnimate),
        userInfo: nil,
        repeats: true)
      startRecording()
    } else {
      animateTimer?.invalidate()
      audioEngine.stop()
      recognitionRequest?.endAudio()
      
      if let text = recordText {
        delegate?.finishRecorder(text)
      }
    }
  }
  
  @objc func handleAnimate() {
    UIView.animate(
      withDuration: 0.25,
      delay: 0,
      options: [.allowUserInteraction],
      animations: {
        self.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
    }) { _ in
      UIView.animate(
        withDuration: 0.25,
        delay: 0,
        options: [.allowUserInteraction],
        animations: {
          self.transform = .identity
      })
    }
  }
  
}
