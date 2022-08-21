//
//  Logger.swift
//
//
//  Created by Yuki Okudera on 2022/08/13.
//

import Foundation

func log(
    _ items: Any...,
    separator: String = " ",
    terminator: String = "\n",
    file: String = #file,
    function: String = #function,
    line: Int = #line
) {
    #if DEBUG
        let fileName = file.components(separatedBy: "/").last ?? ""
        let noBracketsItems: String = {
            var logItems = "\(items)"
            logItems.removeFirst()
            logItems.removeLast()
            return logItems
        }()
        Swift.print("\(fileName) \(function) line:\(line) 🐈 \(noBracketsItems)", separator: separator, terminator: terminator)
    #endif
}
