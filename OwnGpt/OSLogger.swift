//
//  OSLogger.swift
//  OwnGpt
//
//  Created by Bishalw on 6/25/24.
//

import Foundation
import os

protocol Logging {
    func debug(_ message: String, file: String, function: String, line: Int)
    func info(_ message: String, file: String, function: String, line: Int)
    func error(_ message: String, file: String, function: String, line: Int)
    func fault(_ message: String, file: String, function: String, line: Int)
    func warn(_ message: String, file: String, function: String, line: Int)
}

class Log: Logging {
    
    private let logger: Logger
    static let shared = Log(subsystem: "OwnGPT", category: "general")
    
    private init(subsystem: String, category: String) {
        logger = Logger(subsystem: subsystem, category: category)
    }
    
    private func formatMessage(_ message: String, file: String, function: String, line: Int) -> String {
        let fileName = (file as NSString).lastPathComponent
        return """
        [ \(fileName)] | Line [\(line)]
        Function: \(function)
        Log: \(message)
        """
    }
    
    func debug(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        logger.debug("\(self.formatMessage(message, file: file, function: function, line: line))")
    }
    
    func info(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        logger.info("\(self.formatMessage(message, file: file, function: function, line: line))")
    }
    
    func error(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        logger.error("\(self.formatMessage(message, file: file, function: function, line: line))")
    }
    
    func fault(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
        logger.fault("\(self.formatMessage(message, file: file, function: function, line: line))")
    }
    func warn(_ message: String, file: String = #file, function: String = #function, line: Int = #line) {
            logger.warning("\(self.formatMessage(message, file: file, function: function, line: line))")
    }
}
