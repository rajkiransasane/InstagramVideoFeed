//
//  EnvConfig.swift
//  VideoFeeds
//
//  Created by Raj on 17/12/24.
//

import Foundation


private var defaultEnv: EnvironmentType {
    EnvironmentType.stage
}

// Enum for possible values for Different Environments
enum EnvironmentType: String {
    
    case production
    case stage
    
    static func defaultEnvType () -> EnvironmentType {
        return defaultEnv
    }
}
