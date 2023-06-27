//
//  OfflineBannerView.swift
//  MyWeatherApp
//
//  Created by Ajimi Fares on 27/6/2023.
//

import UIKit

class OfflineBannerView: UIView {

    // MARK: Outlets

    @IBOutlet weak var messageLabel: UILabel!

    // MARK: UI

    func setUpView(connected: Bool) {
        if connected {
            let connectedMessage = NSLocalizedString("connectionRestored", comment: "")
            messageLabel.text = connectedMessage
            backgroundColor = .green
            isHidden = false
            DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: { [weak self] in
                self?.isHidden = true
            })
        } else {
            let disconnectedMessage = NSLocalizedString("connectionInterrupted", comment: "")
            messageLabel.text = disconnectedMessage
            backgroundColor = .red
            isHidden = false
        }
    }
}
