//
//  FeedMessageView.swift
//  Photo Feed
//
//  Created by Artem Yakovlev on 24.03.2022.
//

import UIKit

class FeedMessageView: UIView {
    @IBOutlet private weak var label: UILabel!
    @IBOutlet private weak var button: UIButton!
    
    public func setText(_ text: String) {
        label.text = text
    }
    
    @IBAction private func openSettings(_ sender: UIButton) {
        guard
            let settingsUrl = URL(string: UIApplication.openSettingsURLString),
            UIApplication.shared.canOpenURL(settingsUrl)
        else {
            return
        }
        
        UIApplication.shared.open(settingsUrl)
    }
}
