//
//  SpeechService.swift
//  SCTranslation
//
//  Created by 천지운 on 2020/06/26.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import Foundation
import UIKit
import Speech

class SpeechService {
  static let shared = SpeechService()
  private init() { }
  
  private let initSpeech: Bool = false
  let synthesizer = AVSpeechSynthesizer()
  
  func setupSpeech() {
    if !initSpeech {
      let audioSession = AVAudioSession.sharedInstance()
      do {
        try audioSession.setCategory(AVAudioSession.Category.ambient)
        try audioSession.setMode(AVAudioSession.Mode.measurement)
        try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
      } catch {
        print("audioSession properties weren't set because of an error.")
      }
    }
  }
}
