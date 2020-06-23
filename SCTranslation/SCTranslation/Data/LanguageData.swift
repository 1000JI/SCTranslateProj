 //
//  LanguageData.swift
//  SCTranslation
//
//  Created by 천지운 on 2020/06/21.
//  Copyright © 2020 DanBin, JiWoon. All rights reserved.
//

import Foundation

struct Language {
  let country: String
  let transText: String
  let transVoice: String
}

let dataLanguages: [Language] = [
  Language(country: "한국어", transText: "ko", transVoice: "ko-KR"),
  Language(country: "영어", transText: "en", transVoice: "en-US"),
  Language(country: "중국어", transText: "zh", transVoice: "zh-CN"),
  Language(country: "일본어", transText: "ja", transVoice: "ja-JP"),
  Language(country: "독일어", transText: "de", transVoice: "de-DE"),
  Language(country: "힌디어", transText: "hi", transVoice: "hi-IN"),
  Language(country: "프랑스어", transText: "fr", transVoice: "fr-FR"),
  Language(country: "이탈리아어", transText: "it", transVoice: "it-IT"),
  Language(country: "포르투칼어", transText: "pt", transVoice: "pt-PT"),
  Language(country: "러시아어", transText: "ru", transVoice: "ru-RU"),
  Language(country: "스페인어", transText: "es", transVoice: "es-ES"),
  Language(country: "태국어", transText: "th", transVoice: "th-TH")
]
