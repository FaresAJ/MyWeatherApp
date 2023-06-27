//
//  Extensions.swift
//  MyWeatherApp
//
//  Created by Ajimi Fares on 27/6/2023.
//

import UIKit

extension UIView {

    class func fromNib<T: UIView>() -> T? {
        return Bundle(for: T.self).loadNibNamed(String(describing: T.self), owner: nil, options: nil)![0] as? T
    }

    func dropShadow(opacity: Float = 0.1,
                    offSetWidth: Int = 2,
                    offSetHeight: Int = 3,
                    radius: CGFloat = 6) {
        layer.shadowOffset = CGSize(width: offSetWidth, height: offSetHeight)
        layer.shadowRadius = radius
        layer.shadowOpacity = opacity
        layer.masksToBounds = false
        layer.shadowPath = UIBezierPath(rect: self.bounds).cgPath
   }

    func shake() {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0 ]
        layer.add(animation, forKey: "shake")
    }

    func removeAllSubViews() {
        self.subviews.forEach({ $0.removeFromSuperview() })
    }

}

extension UIView {
   func roundCorners(corners: CACornerMask, radius: CGFloat) {
       layer.masksToBounds = true
       layer.cornerRadius = radius
       layer.maskedCorners = corners
    }

    func set(isHidden: Bool) {
        self.isHidden = isHidden
    }
}

// MARK: - Inspectables

extension UIView {

    @IBInspectable var cornerRadius: CGFloat {
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
        }
    }

    @IBInspectable var borderWidth: CGFloat {
        get {
            return layer.borderWidth
        }
        set {
            layer.borderWidth = newValue
        }
    }

    @IBInspectable var borderColor: UIColor? {
        get {
            if let color = layer.borderColor {
                return UIColor(cgColor: color)
            }
            return nil
        }
        set {
            if let color = newValue {
                layer.borderColor = color.cgColor
            } else {
                layer.borderColor = nil
            }
        }
    }
}

// MARK: - UITableView
extension UITableView {
    
    /// Bind a UITableView in order to reload it automatically once the datasource array mutates
    ///
    /// Example:
    /// ```
    /// tableView.bindTo(viewModel.results)
    /// ```
    /// - Parameter bindable: the bounded property
    func bindTo<T>(_ bindable: Dynamic<T>) {
        bindable.bind { [weak self] _ in
            self?.reloadData()
        }
    }
}

// MARK: - UIButton
extension UIButton {
    
    /// Bind a UIButton in order to enable/disable it automatically
    ///
    /// Example:
    /// ```
    /// btnSearch.bindTo(viewModel.isButtonEnabled)
    /// ```
    /// - Parameter bindable: the bounded property
    func bindTo(_ bindable: Dynamic<Bool>) {
        bindable.bind { [weak self] isEnabled in
            self?.isEnabled = true
        }
    }
}

// MARK: - UIActivityIndicatorView
extension UIActivityIndicatorView {
    /// Bind a UIActivityIndicatorView in order to enable/disable  and animate it automatically
    ///
    /// Example:
    /// ```
    /// activityIndicator.bindTo(viewModel.isLoadingEnabled)
    /// ```
    /// - Parameter bindable: the bounded property
    func bindTo(_ bindable: Dynamic<Bool>) {
        bindable.bind { [weak self] isEnabled in
            if isEnabled {
                self?.isHidden = false
                self?.startAnimating()
            } else {
                self?.isHidden = true
                self?.stopAnimating()
            }
        }
    }
}
