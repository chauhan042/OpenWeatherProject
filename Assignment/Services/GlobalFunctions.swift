//
//  APIService.swift
//  Assignment
//
//  Created by Nitin Singh on 11/02/21.
//

import Foundation

enum DebugMessageType: String {
  case info = "ℹ️"
  case warning = "⚠️"
  case error = "💥"
}



func printDebugMessage(domain: String, message: String, type: DebugMessageType = .info) {
 
  guard BuildEnvironment() else {
    return
  }
  debugPrint(
    type
      .rawValue
      .append(contentsOf: domain, delimiter: .space)
      .append(contentsOf: message, delimiter: .custom(string: " : "))
  )
}

func BuildEnvironment() -> Bool{
    #if DEBUG
     return true
    #endif
}
