//
//  SALPayCell.swift
//  Example
//
//  Created by Salarium on 04/06/2018.
//  Copyright © 2018 Xmartlabs. All rights reserved.
//

import Foundation
#if XLACTIONCONTROLLER_EXAMPLE
import XLActionController
#endif

open class SALPayCell: ActionCell {
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    func initialize() {
        backgroundColor = .clear
        let backgroundView = UIView()
        backgroundView.backgroundColor = UIColor.white.withAlphaComponent(0.3)
        selectedBackgroundView = backgroundView
        actionTitleLabel?.textColor = .black
        actionTitleLabel?.textAlignment = .left
        
    }
}

public struct SALPayHeaderData {
    
    var title: String
    var subtitle: String
    var image: UIImage
    var headerIconTintColor : UIColor
    
    
    public init(title: String, subtitle: String, image: UIImage, headertintColor:UIColor) {
        self.title = title
        self.subtitle = subtitle
        self.image = image
        self.headerIconTintColor = headertintColor
    }
}

open class SALPayHeaderView: UICollectionReusableView {
    
    open lazy var imageView: UIImageView = {
        let imageView = UIImageView(frame: CGRect.zero)
        imageView.image = UIImage(named: "sp-header-icon")
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    open lazy var title: UILabel = {
        let title = UILabel(frame: CGRect.zero)
        title.text = "The Fast And ... The Furious Soundtrack Collection"
        title.textColor = UIColor.black
        title.font = UIFont.systemFont(ofSize: 16)
        title.translatesAutoresizingMaskIntoConstraints = false
        title.sizeToFit()
        return title
    }()
    
    open lazy var artist: UILabel = {
        let discArtist = UILabel(frame: CGRect.zero)
        discArtist.text = "Various..."
        discArtist.font = UIFont.systemFont(ofSize: 12)
        discArtist.textColor = UIColor.black.withAlphaComponent(0.8)
        discArtist.translatesAutoresizingMaskIntoConstraints = false
        discArtist.sizeToFit()
        return discArtist
    }()
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        initialize()
    }
    
    func initialize() {
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        addSubview(imageView)
        addSubview(title)
        addSubview(artist)
        
        let separator: UIView = {
            let separator = UIView(frame: CGRect.zero)
            separator.backgroundColor = UIColor.black.withAlphaComponent(0.1)
            separator.translatesAutoresizingMaskIntoConstraints = false
            return separator
        }()
        addSubview(separator)
        
        let views = [ "ico": imageView, "title": title, "artist": artist, "separator": separator ]
        let metrics = [ "icow": 30, "icoh": 30 ]
        let options = NSLayoutFormatOptions()
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[ico(icow)]-20-[title]-15-|", options: options, metrics: metrics, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[separator]|", options: options, metrics: metrics, views: views))
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[ico(icoh)]", options: options, metrics: metrics, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-18-[title][artist]", options: .alignAllLeft, metrics: metrics, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[separator(1)]|", options: options, metrics: metrics, views: views))
    }
}


open class SALPayActionController: ActionController<SALPayCell, ActionData, SALPayHeaderView, SALPayHeaderData, UICollectionReusableView, Void> {
    
    fileprivate lazy var blurView: UIVisualEffectView = {
        let blurView = UIVisualEffectView(effect: UIBlurEffect(style: .extraLight))
        blurView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        return blurView
    }()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    open override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
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
