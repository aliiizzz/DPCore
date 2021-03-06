//
//  CenteredCollectionViewLayout.swift
//  DPCore
//
//  Created by Farshad Mousalou on 11/15/18.
//  Copyright © 2018 DigiPay. All rights reserved.
//

import Foundation

class CenteredCollectionViewLayout: AnimatedCollectionViewLayout {
    
    private var lastCollectionViewSize: CGSize = CGSize.zero
    private var lastScrollDirection: UICollectionViewScrollDirection!
    private var lastItemSize: CGSize = CGSize.zero
    
    var pageWidth: CGFloat {
        switch scrollDirection {
        case .horizontal:
            return itemSize.width + minimumLineSpacing
        case .vertical:
            return itemSize.height + minimumLineSpacing
        }
    }
    
    /// Calculates the current centered page.
    var currentCenteredPage: Int? {
        guard let collectionView = collectionView else { return nil }
        let currentCenteredPoint = CGPoint(x: collectionView.contentOffset.x + collectionView.bounds.width/2, y: collectionView.contentOffset.y + collectionView.bounds.height/2)
        
        return collectionView.indexPathForItem(at: currentCenteredPoint)?.row
    }
    
    /*
    override open func invalidateLayout(with context: UICollectionViewLayoutInvalidationContext) {
        super.invalidateLayout(with: context)
        guard let collectionView = collectionView else { return }
        
        // invalidate layout to center first and last
        let currentCollectionViewSize = collectionView.bounds.size
        if !currentCollectionViewSize.equalTo(lastCollectionViewSize) || lastScrollDirection != scrollDirection || lastItemSize != itemSize {
            switch scrollDirection {
            case .horizontal:
                let inset = (currentCollectionViewSize.width - itemSize.width) / 2
                collectionView.contentInset = UIEdgeInsets(top: 0, left: inset, bottom: 0, right: inset)
                collectionView.contentOffset = CGPoint(x: -inset, y: 0)
            case .vertical:
                let inset = (currentCollectionViewSize.height - itemSize.height) / 2
                collectionView.contentInset = UIEdgeInsets(top: inset, left: 0, bottom: inset, right: 0)
                collectionView.contentOffset = CGPoint(x: 0, y: -inset)
            }
            lastCollectionViewSize = currentCollectionViewSize
            lastScrollDirection = scrollDirection
            lastItemSize = itemSize
        }
    }*/
    
//    override open func targetContentOffset(forProposedContentOffset proposedContentOffset: CGPoint, withScrollingVelocity velocity: CGPoint) -> CGPoint {
//        guard let collectionView = collectionView else { return proposedContentOffset }
//        
//        let proposedRect: CGRect = determineProposedRect(collectionView: collectionView, proposedContentOffset: proposedContentOffset)
//        
//        guard let layoutAttributes = layoutAttributesForElements(in: proposedRect),
//            let candidateAttributesForRect = attributesForRect(
//                collectionView: collectionView,
//                layoutAttributes: layoutAttributes,
//                proposedContentOffset: proposedContentOffset
//            ) else { return proposedContentOffset }
//        
//        var newOffset: CGFloat
//        let offset: CGFloat
//        switch scrollDirection {
//        case .horizontal:
//            newOffset = candidateAttributesForRect.center.x - collectionView.bounds.size.width / 2
//            offset = newOffset - collectionView.contentOffset.x
//            
//            if (velocity.x < 0 && offset > 0) || (velocity.x > 0 && offset < 0) {
//                let pageWidth = itemSize.width + minimumLineSpacing
//                newOffset += velocity.x > 0 ? pageWidth : -pageWidth
//            }
//            return CGPoint(x: newOffset, y: proposedContentOffset.y)
//            
//        case .vertical:
//            newOffset = candidateAttributesForRect.center.y - collectionView.bounds.size.height / 2
//            offset = newOffset - collectionView.contentOffset.y
//            
//            if (velocity.y < 0 && offset > 0) || (velocity.y > 0 && offset < 0) {
//                let pageHeight = itemSize.height + minimumLineSpacing
//                newOffset += velocity.y > 0 ? pageHeight : -pageHeight
//            }
//            return CGPoint(x: proposedContentOffset.x, y: newOffset)
//        }
//    }
//    
//    /// Programmatically scrolls to a page at a specified index.
//    ///
//    /// - Parameters:
//    ///   - index: The index of the page to scroll to.
//    ///   - animated: Whether the scroll should be performed animated.
//    public func scrollToPage(index: Int, animated: Bool) {
//        guard let collectionView = collectionView else { return }
//        
//        let proposedContentOffset: CGPoint
//        let shouldAnimate: Bool
//        switch scrollDirection {
//        case .horizontal:
//            let pageOffset = CGFloat(index) * pageWidth - collectionView.contentInset.left
//            proposedContentOffset = CGPoint(x: pageOffset, y: collectionView.contentOffset.y)
//            shouldAnimate = fabs(collectionView.contentOffset.x - pageOffset) > 1 ? animated : false
//        case .vertical:
//            let pageOffset = CGFloat(index) * pageWidth - collectionView.contentInset.top
//            proposedContentOffset = CGPoint(x: collectionView.contentOffset.x, y: pageOffset)
//            shouldAnimate = fabs(collectionView.contentOffset.y - pageOffset) > 1 ? animated : false
//        }
//        collectionView.setContentOffset(proposedContentOffset, animated: shouldAnimate)
//    }
//    
}

private extension CenteredCollectionViewLayout {
    
    func determineProposedRect(collectionView: UICollectionView, proposedContentOffset: CGPoint) -> CGRect {
        let size = collectionView.bounds.size
        let origin: CGPoint
        switch scrollDirection {
        case .horizontal:
            origin = CGPoint(x: proposedContentOffset.x, y: collectionView.contentOffset.y)
        case .vertical:
            origin = CGPoint(x: collectionView.contentOffset.x, y: proposedContentOffset.y)
        }
        return CGRect(origin: origin, size: size)
    }
    
    func attributesForRect(
        collectionView: UICollectionView,
        layoutAttributes: [UICollectionViewLayoutAttributes],
        proposedContentOffset: CGPoint
        ) -> UICollectionViewLayoutAttributes? {
        
        var candidateAttributes: UICollectionViewLayoutAttributes?
        let proposedCenterOffset: CGFloat
        
        switch scrollDirection {
        case .horizontal:
            proposedCenterOffset = proposedContentOffset.x + collectionView.bounds.size.width / 2
        case .vertical:
            proposedCenterOffset = proposedContentOffset.y + collectionView.bounds.size.height / 2
        }
        
        for attributes in layoutAttributes {
            guard attributes.representedElementCategory == .cell else { continue }
            guard candidateAttributes != nil else {
                candidateAttributes = attributes
                continue
            }
            
            switch scrollDirection {
            case .horizontal where fabs(attributes.center.x - proposedCenterOffset) < fabs(candidateAttributes!.center.x - proposedCenterOffset):
                candidateAttributes = attributes
            case .vertical where fabs(attributes.center.y - proposedCenterOffset) < fabs(candidateAttributes!.center.y - proposedCenterOffset):
                candidateAttributes = attributes
            default:
                continue
            }
        }
        return candidateAttributes
    }
}
