//
//  ScaleAspectFitImageView.swift
//  ANF Code Test
//
//  Created by Hana on 1/26/25.
//

import UIKit

public class ScaleAspectFitImageView : UIImageView {
    
    // MARK: properites
    private var aspectRatioConstraint:NSLayoutConstraint? = nil
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)
        self.setup()
    }
    
    // MARK: init
    public override init(frame:CGRect) {
        super.init(frame:frame)
        self.setup()
    }
    
    public override init(image: UIImage?) {
        super.init(image:image)
        self.setup()
    }
    
    public override init(image: UIImage?, highlightedImage: UIImage?) {
        super.init(image:image,highlightedImage:highlightedImage)
        self.setup()
    }
    
    // MARK: override properites
    override public var image: UIImage? {
        didSet {
            self.updateAspectRatioConstraint()
        }
    }
    
    // MARK: methods 
    private func setup() {
        self.contentMode = .scaleAspectFit
        self.updateAspectRatioConstraint()
    }
    
    private func updateAspectRatioConstraint() {
        // remove any existing aspect ratio constraint
        if let constaint = self.aspectRatioConstraint {
            self.removeConstraint(constaint)
        }
        self.aspectRatioConstraint = nil
        
        if let imageSize = image?.size, imageSize.height != 0 {
            let aspectRatio = imageSize.width / imageSize.height
            let constraint = NSLayoutConstraint(item: self, attribute: .width,
                                       relatedBy: .equal,
                                       toItem: self, attribute: .height,
                                       multiplier: aspectRatio, constant: 0)
            
            // reduce the priority 
            constraint.priority = UILayoutPriority(999)
            self.addConstraint(constraint)
            self.aspectRatioConstraint = constraint
            self.aspectRatioConstraint?.isActive = true
        }
    }
}
