//
//  TranslateService.swift
//  SCTranslation
//
//  Created by 천지운 on 2020/06/22.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import Firebase

struct TranslateService {
  
  static func translateText(from fromLanguage: Language, to toLanguage: Language, sourceText: String, completion: @escaping(String) -> Void) {
    // Create an English-German translator:
    let from = TranslateLanguage.fromLanguageCode(fromLanguage.transText)
    let to = TranslateLanguage.fromLanguageCode(toLanguage.transText)
    
    let options = TranslatorOptions(sourceLanguage: from, targetLanguage: to)
    let englishGermanTranslator = NaturalLanguage.naturalLanguage().translator(options: options)
    
    let conditions = ModelDownloadConditions(
      allowsCellularAccess: false,
      allowsBackgroundDownloading: true
    )
    englishGermanTranslator.downloadModelIfNeeded(with: conditions) { error in
      guard error == nil else { return }
      
      // Model downloaded successfully. Okay to start translating.
    }
    
    englishGermanTranslator.translate(sourceText) { translatedText, error in
      guard error == nil, let translatedText = translatedText else {
        print(#function, "DEBUG2: \(error!.localizedDescription)")
        englishGermanTranslator.downloadModelIfNeeded(with: conditions) { error in
          print(error?.localizedDescription ?? "")
        }
        return
      }
      // Translation succeeded.
      completion(translatedText)
    }
  }
  
}
