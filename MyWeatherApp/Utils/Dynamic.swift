//
//  Dynamic.swift
//  MyWeatherApp
//
//  Created by Ajimi Fares on 27/6/2023.
//

import Foundation

class Dynamic<T> {
    
    private var listener: ((T) -> Void)?
    
    var value: T {
        didSet { fireListenerOnMainThread() }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ listener: @escaping (T) -> Void) {
        self.listener = listener
        fireListenerOnMainThread()
    }
    
    private func fireListenerOnMainThread() {
        DispatchQueue.main.async { [weak self] in
            guard let gSelf = self,
            let gListener = gSelf.listener else { return }
            gListener(gSelf.value)
        }
    }
}
