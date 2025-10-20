//
//  GlobalDefinitions.swift
//  Soccer
//
//  Created by Andrey Chernyshev on 16.01.2021.
//

import Foundation

final class GlobalDefinitions {
    static let otterScaleHost = "https://api.korrekted.com"
    static let otterScaleApiKey = "qWzYSh1J5aHKtG6l"
    
    static let termsOfServiceUrl = URL(string: "https://apps-and-taps.com/terms")!
    static let privacyPolicyUrl = URL(string: "https://apps-and-taps.com/policy")!
    static let contactUsUrl = URL(string: "https://apps-and-taps.com/#contact")!
    
    // TODO
    enum Paygate {
        static let yearly = "iphone.santa.chat.yearly"
        static let weekly = "iphone.santa.chat.weekly"
    }
}
