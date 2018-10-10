//
//  SALPayActionViewController.swift
//  Example
//
//  Created by MAC HOME on 10/10/2018.
//  Copyright © 2018 Xmartlabs. All rights reserved.
//

import Foundation
#if XLACTIONCONTROLLER_EXAMPLE
import XLActionController
#endif


open class SALPayActionController: ActionController<SALPayCell, ActionData, SALPayHeaderView, SALPayHeaderData, UICollectionReusableView, Void> {
    
    fileprivate lazy var blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .light))
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return blurView
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        backgroundView.addSubview(blurView)
        
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        blurView.frame = backgroundView.bounds
    }
    
    public override init(nibName nibNameOrNil: String? = nil, bundle nibBundleOrNil: Bundle? = nil) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        settings.behavior.bounces = true
        settings.behavior.scrollEnabled = true
        settings.cancelView.showCancel = false
        settings.animation.scale = nil
        settings.animation.present.springVelocity = 0.0
        settings.cancelView.hideCollectionViewBehindCancelView = true
        
        cellSpec = .nibFile(nibName: "SALPayCell", bundle: Bundle(for: SALPayCell.self), height: { _ in 60 })
        headerSpec = .cellClass( height: { _ in 65 })
        
        onConfigureCellForAction = { [weak self] cell, action, indexPath in
            cell.setup(action.data?.title, detail: action.data?.subtitle, image: action.data?.image)
            cell.actionTitleLabel?.font = UIFont.systemFont(ofSize: 16)
            cell.actionDetailLabel?.font = UIFont.systemFont(ofSize: 12)
            cell.backgroundColor = UIColor.white
            cell.separatorView?.isHidden = indexPath.item == (self?.collectionView.numberOfItems(inSection: indexPath.section))! - 1
            cell.alpha = action.enabled ? 1.0 : 0.5
        }
        onConfigureHeader = { (header: SALPayHeaderView, data: SALPayHeaderData)  in
            header.backgroundColor = UIColor.white
            header.title.text = data.title
            header.artist.text = data.subtitle
            header.imageView.image = data.image
            header.imageView.tintColor = data.headerIconTintColor
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func performCustomDismissingAnimation(_ presentedView: UIView, presentingView: UIView) {
        super.performCustomDismissingAnimation(presentedView, presentingView: presentingView)
        cancelView?.frame.origin.y = view.bounds.size.height + 10
    }
    
    open override func onWillPresentView() {
        cancelView?.frame.origin.y = view.bounds.size.height
    }
}
