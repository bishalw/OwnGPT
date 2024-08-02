//
//  OSLogger.swift
//  OwnGpt
//
//  Created by Bishalw on 6/25/24.
//

import Foundation
import Bkit
import os

public class Log {
    public static let shared = Log()
    
    public let logger: LoggerManager
    
    private init() {
        self.logger = LoggerManager(subsystem: "OwngGPT", category: "AppLogs")
    }
}


