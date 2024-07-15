//
//  Config.swift
//  KidsNoteGoogleBookTask
//
//  Created by 이승기 on 7/15/24.
//

import Foundation

struct Config {
    static var apiKey: String {
        let bundle = Bundle(identifier: "com.seunggi.KidsNoteGoogleBookTask")!
        guard let filePath = bundle.path(forResource: "Info", ofType: "plist"),
              let plistDict = NSDictionary(contentsOfFile: filePath) else {
            fatalError("Couldn't find file 'Info.plst'.")
        }
        
        guard let apiKey = plistDict.object(forKey: "API_KEY") as? String else {
            fatalError("API Key not found in Info.plist")
        }
        return apiKey
    }
}
