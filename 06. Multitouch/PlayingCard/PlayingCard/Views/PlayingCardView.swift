//
//  PlayingCardView.swift
//  PlayingCard
//
//  Created by Developer on 22/07/2018.
//  Copyright © 2018 development. All rights reserved.
//

import UIKit

@IBDesignable
class PlayingCardView: UIView
{
    // ============================================================================================================
    // Properties
    // ============================================================================================================
    // Mark "Needs to be redrawn" on value change
    @IBInspectable
    var rank: Int = 12 { didSet { setNeedsDisplay(); setNeedsLayout() } }

    @IBInspectable
    var suit: String = "♥️" { didSet { setNeedsDisplay(); setNeedsLayout() } }

    @IBInspectable
    var isFaceUp: Bool = true { didSet { setNeedsDisplay(); setNeedsLayout() } }
    
    var faceCardScale = SizeRatio.faceCardImageSizeToBoundSize { didSet { setNeedsDisplay(); setNeedsLayout() } }
    // ============================================================================================================
    
    // Handler for "Pinch" gesture
    @objc func adjustFaceCardScale(byHandlingGestureRecognizedBy recognizer: UIPinchGestureRecognizer) {
        switch recognizer.state {
            case .changed, .ended:
                faceCardScale *= recognizer.scale
                recognizer.scale = 1.0 // [!]: Makes the changes of the scale _incremental_
            default: break
        }
    }
    
    // Helper function
    // Input: a [font] and [size]
    // Output: NS-attributed [font] and [size]
    private func centerAttributedString(_ string: String, fontSize: CGFloat) -> NSAttributedString
    {
        // Automatic font scaling
        var font = UIFont.preferredFont(forTextStyle: .body).withSize(fontSize)
        font = UIFontMetrics(forTextStyle: .body).scaledFont(for: font)
        
        // Paragraph style
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.alignment = .center
        
        // Return an NSAttributedString
        return NSAttributedString(string: string, attributes: [NSAttributedStringKey.paragraphStyle : paragraphStyle, NSAttributedStringKey.font : font])
    }
    
    // Helper
    private var cornerString: NSAttributedString
    {
        return centerAttributedString(rankString + "\n" + suit, fontSize: cornerFontSize)
    }
    
    lazy private var upperLeftCornerLabel = createCornerLabel()
    lazy private var lowerRightCornerLabel = createCornerLabel()
        
    private func createCornerLabel() -> UILabel
    {
        let label = UILabel()
        label.numberOfLines = 0 // Use as many as you wish
        addSubview(label)
        return label
    }
    
    // Force redraw of fonts
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?)
    {
        setNeedsDisplay()
        setNeedsLayout()
    }
    
    // When orientation changes
    override func layoutSubviews()
    {
        
        super.layoutSubviews()
        
        configureCornerLabel(upperLeftCornerLabel)
        
        // Card symbol: Make the bottom right corner symbol upside-down
        lowerRightCornerLabel.transform = CGAffineTransform.identity
            .translatedBy(x: lowerRightCornerLabel.frame.size.width, y: lowerRightCornerLabel.frame.size.height) // Move it
            .rotated(by: CGFloat.pi)                                                                             // Rotate it
        configureCornerLabel(lowerRightCornerLabel)
        
        upperLeftCornerLabel.frame.origin = bounds.origin.offsetBy(dx: cornerOffset, dy: cornerOffset)
        lowerRightCornerLabel.frame.origin = CGPoint(x: bounds.maxX, y: bounds.maxY)
            .offsetBy(dx: -cornerOffset, dy: -cornerOffset)
            .offsetBy(dx: -lowerRightCornerLabel.frame.size.width, dy: -lowerRightCornerLabel.frame.size.height )
    }
    
    // Draws the icons inside the center of the card
    private func drawPips()
    {
        let pipsPerRowForRank = [[0], [1], [1,1], [1,1,1], [2,2], [2,1,2], [2,2,2], [2,1,2,2], [2,2,2,2], [2,2,1,2,2], [2,2,2,2,2]]
        
        func createPipString(thatFits pipRect: CGRect) -> NSAttributedString {
            let maxVerticalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.count, $0)})
            let maxHorizontalPipCount = CGFloat(pipsPerRowForRank.reduce(0) { max($1.max() ?? 0, $0)})
            let verticalPipRowSpacing = pipRect.size.height / maxVerticalPipCount
            let attemptedPipString = centerAttributedString(suit, fontSize: verticalPipRowSpacing)
            let probablyOkayPipStringFontSize = verticalPipRowSpacing / (attemptedPipString.size().height / verticalPipRowSpacing)
            let probablyOkayPipString = centerAttributedString(suit, fontSize: probablyOkayPipStringFontSize)
            if probablyOkayPipString.size().width > pipRect.size.width / maxHorizontalPipCount {
                return centerAttributedString(suit, fontSize: probablyOkayPipStringFontSize /
                    (probablyOkayPipString.size().width / (pipRect.size.width / maxHorizontalPipCount)))
            } else {
                return probablyOkayPipString
            }
        }
        
        if pipsPerRowForRank.indices.contains(rank) {
            let pipsPerRow = pipsPerRowForRank[rank]
            var pipRect = bounds.insetBy(dx: cornerOffset, dy: cornerOffset).insetBy(dx: cornerString.size().width, dy: cornerString.size().height / 2)
            let pipString = createPipString(thatFits: pipRect)
            let pipRowSpacing = pipRect.size.height / CGFloat(pipsPerRow.count)
            pipRect.size.height = pipString.size().height
            pipRect.origin.y += (pipRowSpacing - pipRect.size.height) / 2
            for pipCount in pipsPerRow {
                switch pipCount {
                case 1:
                    pipString.draw(in: pipRect)
                case 2:
                    pipString.draw(in: pipRect.leftHalf)
                    pipString.draw(in: pipRect.rightHalf)
                default:
                    break
                }
                pipRect.origin.y += pipRowSpacing
            }
        }
    }
    
    private func configureCornerLabel(_ label: UILabel)
    {
        label.attributedText = cornerString
        label.frame.size = CGSize.zero // [!] - Reset size
        label.sizeToFit()
        label.isHidden = !isFaceUp
    }
    
    
    // Only override draw() if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func draw(_ rect: CGRect)
    {
        // ====================================================
        // Drawing: Method 1 - via [context]
        // ====================================================
        //        if let context = UIGraphicsGetCurrentContext()
        //        {
        //            // Get contexts
        //            context.addArc(center: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        //
        //            // Set colors
        //            context.setLineWidth(5.0)
        //            UIColor.green.setFill()
        //            UIColor.red.setStroke()
        //
        //            // Apply context settings
        //            context.strokePath() // Warning: This "consumes" the [path] object.
        //            context.fillPath() // So this next line, the path will not be filled, because [path] has been already consumed!
        //
        //        }
        // ------------------------------------------------------
        
        // ====================================================
        // Drawing: Method 2 - via [UIBezier]
        // ====================================================
        // Difference: with the [UIBezierPath] method, the created [path] object can be used over and over - it is not bound to the current [context]
        //        let path = UIBezierPath()
        //        path.addArc(withCenter: CGPoint(x: bounds.midX, y: bounds.midY), radius: 100.0, startAngle: 0, endAngle: 2*CGFloat.pi, clockwise: true)
        //
        //        // Set colors
        //        path.lineWidth = 5.0
        //
        //        UIColor.green.setFill()
        //        UIColor.red.setStroke()
        //
        //        path.stroke()
        //        path.fill()
        // ------------------------------------------------------
        
        // ====================================================
        // Drawing: Drawing intersected elements
        // ====================================================
        let roundedRect = UIBezierPath(roundedRect: bounds, cornerRadius: cornerRadius)
        roundedRect.addClip()
        UIColor.white.setFill()
        roundedRect.fill()
        
        if isFaceUp
        {
            // Case: It is a face card
            if let cardFaceImage = UIImage(named: rankString + suit, in: Bundle(for: self.classForCoder), compatibleWith: traitCollection)
            {
                cardFaceImage.draw(in: bounds.zoom(by: faceCardScale))
            }
            // Case: Not a face card
            else
            {
                print("entered drawPips()")
                drawPips()
            }
        }
        else
        {
            if let cardBackImage = UIImage(named: "cardback", in: Bundle(for: self.classForCoder), compatibleWith: traitCollection)
            {
                cardBackImage.draw(in: bounds)
            }
            else { print("card not found!") }
        }
        
    }

}

// ===============================================================================
// EXTENSIONS
// ===============================================================================

extension PlayingCardView {
    
    // Setting constants
    private struct SizeRatio
    {
        static let cornerFontSizeToBoundHeight: CGFloat     = 0.085
        static let cornerRadiusToBoundHeight: CGFloat       = 0.06
        static let cornerOffsetToCornerRadius: CGFloat      = 0.33
        static let faceCardImageSizeToBoundSize: CGFloat    = 0.63
    }
    
    private var cornerRadius: CGFloat
    {
        return bounds.size.height * SizeRatio.cornerRadiusToBoundHeight
    }
    
    private var cornerOffset: CGFloat
    {
        return cornerRadius * SizeRatio.cornerOffsetToCornerRadius
    }
    
    private var cornerFontSize: CGFloat
    {
        return bounds.size.height * SizeRatio.cornerFontSizeToBoundHeight
    }
    
    private var rankString: String
    {
        switch rank
        {
            case 1:
                return "A"
            case 2...10: return
                String(rank)
            case 11:
                return "J"
            case 12:
                return "Q"
            case 13:
                return "K"
            default:
                return "?"
        }
    }
}

extension CGPoint {
    func offsetBy(dx: CGFloat, dy: CGFloat) -> CGPoint {
        return CGPoint(x: x + dx, y: y + dy)
    }
}

extension CGRect {
    func zoom(by zoomFactor: CGFloat) -> CGRect {
        let zoomedWidth = size.width * zoomFactor
        let zoomedHeight = size.height * zoomFactor
        let originX = origin.x + (size.width - zoomedWidth) / 2
        let originY = origin.y + (size.height - zoomedHeight) / 2
        return CGRect(origin: CGPoint(x: originX,y: originY) , size: CGSize(width: zoomedWidth, height: zoomedHeight))
    }
    
    var leftHalf: CGRect {
        let width = size.width / 2
        return CGRect(origin: origin, size: CGSize(width: width, height: size.height))
    }
    
    var rightHalf: CGRect {
        let width = size.width / 2
        return CGRect(origin: CGPoint(x: origin.x + width, y: origin.y), size: CGSize(width: width, height: size.height))
    }
}
