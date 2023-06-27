//
//  BaseViewController.swift
//  MyWeatherApp
//
//  Created by Ajimi Fares on 26/6/2023.
//

import UIKit

class BaseViewController: UIViewController {

    lazy var banner: OfflineBannerView? = .fromNib()
    var isConnected = false
    private var isConnexionInterrupted = false
    internal var refreshControl: UIRefreshControl?

    // MARK: View lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        setupHideKeyboardOnTap()
        setUpConnectivitySubscribers()
        NetworkReachability.shared.startMonitoring()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }

    // MARK: Offline banner

    private func setUpConnectivitySubscribers() {
        setUpOfflineView()
        updateBanner()
        // Observe network reachability changes
        NotificationCenter.default.addObserver(self, selector: #selector(networkReachable), name: .networkReachable, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(networkUnavailable), name: .networkUnavailable, object: nil)
    }
    
    // Handle network reachability changes
    @objc func networkReachable() {
        print("Network is reachable.")
        // Perform actions when the network becomes reachable
        self.isConnected = true
        self.updateBanner()
        if isConnected && self.isConnexionInterrupted {
            self.refreshAfterReEstablishingConnexion()
        }
        self.isConnexionInterrupted = isConnected ? false : true
    }

    @objc func networkUnavailable() {
        print("Network connection interrupted.")
        // Perform actions when the network connection is interrupted
        self.isConnected = false
        self.updateBanner()
        if isConnected && self.isConnexionInterrupted {
            self.refreshAfterReEstablishingConnexion()
        }
        self.isConnexionInterrupted = isConnected ? false : true
    }


    private func setUpOfflineView() {
        guard let banner = banner else {return}
        banner.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(banner)

        NSLayoutConstraint.activate([
            banner.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            banner.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            banner.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            banner.heightAnchor.constraint(equalToConstant: 32)
        ])
    }

    private func updateBanner() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            if self.isConnexionInterrupted {
                self.banner?.setUpView(connected: self.isConnected)
            } else {
                self.banner?.isHidden = true
            }
        }
    }

    // MARK: refresh data (connection is re-established)

    func refreshAfterReEstablishingConnexion() {
        // override and implment the reload data
    }

    // MARK: dismiss keyboard on screen touch

       func setupHideKeyboardOnTap() {
           self.view.addGestureRecognizer(self.endEditingRecognizer())
           self.navigationController?.navigationBar.addGestureRecognizer(self.endEditingRecognizer())
       }

       private func endEditingRecognizer() -> UIGestureRecognizer {
           let tap = UITapGestureRecognizer(target: self.view, action: #selector(self.view.endEditing(_:)))
           tap.cancelsTouchesInView = false
           return tap
       }

    // MARK: pull to refresh

    func setUpPullToRefresh(action: Selector, tableView: UITableView) {
        refreshControl = UIRefreshControl()
        guard let refreshControl = refreshControl else { return }
        refreshControl.addTarget(self, action: action, for: .valueChanged)
        refreshControl.tintColor = .green
        tableView.addSubview(refreshControl)
    }
}
