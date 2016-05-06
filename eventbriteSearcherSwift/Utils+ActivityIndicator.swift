//
//  Utils.swift
//  eventbriteSearcherSwift
//
//  Created by Leonardo Salmaso on 5/5/16.
//  Copyright © 2016 Leonardo Salmaso. All rights reserved.
//

import UIKit


extension Utils {
    class CustomActivityIndicator: UIView {
        let containerView: UIView
        let loadingIndicatorImageView: UIImageView
        let mainView: UIView
        let images: [UIImage]

        init(width:CGFloat, height:CGFloat, images:[UIImage], backgroundColor:UIColor, showInView mainView:UIView) {
            containerView = UIView()
            loadingIndicatorImageView = UIImageView()
            self.mainView = mainView
            self.images = images
            
            containerView.translatesAutoresizingMaskIntoConstraints = false
            loadingIndicatorImageView.translatesAutoresizingMaskIntoConstraints = false
            loadingIndicatorImageView.autoresizesSubviews = true
            loadingIndicatorImageView.contentMode = .ScaleAspectFit
            
            containerView.backgroundColor = backgroundColor
            
            super.init(frame: mainView.bounds)

            containerView.addSubview(loadingIndicatorImageView)
            mainView.addSubview(containerView)

            addConstraintsForLoadingIndicator(width: width, height: height)
            addConstraintsForContainerView()
            addConstraintsForMainView()
            stop()
        }

        required init?(coder aDecoder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
        
        private func addConstraintsForContainerView() {
            let xCenterConstraint = NSLayoutConstraint(item: loadingIndicatorImageView, attribute: .CenterX, relatedBy: .Equal, toItem: containerView, attribute: .CenterX, multiplier: 1, constant: 0)
            let yCenterConstraint = NSLayoutConstraint(item: loadingIndicatorImageView, attribute: .CenterY, relatedBy: .Equal, toItem: containerView, attribute: .CenterY, multiplier: 1, constant: 0)
            
            containerView.addConstraints([xCenterConstraint, yCenterConstraint])
        }

        private func addConstraintsForLoadingIndicator(width width: CGFloat, height: CGFloat) {
            let widthConstraint = NSLayoutConstraint(item: loadingIndicatorImageView, attribute: NSLayoutAttribute.Width, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: width)
            let heightConstraint = NSLayoutConstraint(item: loadingIndicatorImageView, attribute: NSLayoutAttribute.Height, relatedBy: NSLayoutRelation.Equal, toItem: nil, attribute: NSLayoutAttribute.NotAnAttribute, multiplier: 1, constant: height)
            
            loadingIndicatorImageView.addConstraints([widthConstraint, heightConstraint]);
        }
        
        private func addConstraintsForMainView() {
            let leadingConstraint = NSLayoutConstraint(item: containerView, attribute: .Leading, relatedBy: .Equal, toItem: mainView, attribute: .Leading, multiplier: 1, constant: 0)
            let trailingConstraint = NSLayoutConstraint(item: containerView, attribute: .Trailing, relatedBy: .Equal, toItem: mainView, attribute: .Trailing, multiplier: 1, constant: 0)
            let topConstraint = NSLayoutConstraint(item: containerView, attribute: .Top, relatedBy: .Equal, toItem: mainView, attribute: .Top, multiplier: 1, constant: 0)
            let bottomConstraint = NSLayoutConstraint(item: containerView, attribute: .Bottom, relatedBy: .Equal, toItem: mainView, attribute: .Bottom, multiplier: 1, constant: 0)
            
            mainView.addConstraints([leadingConstraint, trailingConstraint, topConstraint, bottomConstraint]);
        }
        
        func start() {
            containerView.hidden = false
            loadingIndicatorImageView.hidden = false
            loadingIndicatorImageView.animationImages = images;
            loadingIndicatorImageView.animationDuration = 0.7
            loadingIndicatorImageView.startAnimating()
        }
        
        func stop() {
            loadingIndicatorImageView.stopAnimating()
            loadingIndicatorImageView.hidden = true
            containerView.hidden = true
        }
    }
}