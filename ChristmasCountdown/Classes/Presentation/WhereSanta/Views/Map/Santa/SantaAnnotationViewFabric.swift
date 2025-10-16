//
//  SantaAnnotationViewFabric.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 15.10.2025.
//

import UIKit
import MapKit

final class SantaAnnotationViewFabric {
    enum Constants {
        static let id = "santa_id"
    }
}

// MARK: Public
extension SantaAnnotationViewFabric {
    func make(mapView: MKMapView, annotation: SantaAnnotation) -> MKAnnotationView {
        let composed = makeImage(with: "I’m in \(annotation.place)!")
        
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.id) ?? MKAnnotationView(annotation: annotation, reuseIdentifier: Constants.id)
        view.annotation = annotation
        view.image = composed
        view.centerOffset = CGPoint(x: 0, y: -composed.size.height / 2.0)
        return view
    }
}

// MARK: Private
private extension SantaAnnotationViewFabric {
    func makeImage(with text: String) -> UIImage {
        let santaSize = CGSize(width: 112.scale, height: 124.scale)
        let santa = resize(image: UIImage(named: "WhereSanta.Annotation.Santa")!, to: santaSize)
        
        let textAttrs = TextAttributes()
            .textColor(UIColor.black)
            .font(Fonts.NewYork.mediumBold(size: 17.scale))
        let textBounds = (text as NSString).boundingRect(
            with: CGSize(width: 153.scale, height: CGFloat.greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: textAttrs.dictionary, context: nil
        ).integral

        let bubbleHPad: CGFloat = 16.scale
        let bubbleVPad: CGFloat = 12.scale
        let tailSize: CGFloat = 14.scale
        let bubbleSize = CGSize(
            width: textBounds.width + bubbleHPad * 2,
            height: textBounds.height + bubbleVPad * 2
        )

        let totalW = max(bubbleSize.width, santaSize.width)
        let totalH = bubbleSize.height + tailSize + santaSize.height

        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        
        return UIGraphicsImageRenderer(size: CGSize(width: totalW, height: totalH), format: format).image { ctx in
            let bubbleX = (totalW - bubbleSize.width) / 2.0
            let bubbleRect = CGRect(x: bubbleX, y: 0, width: bubbleSize.width, height: bubbleSize.height)

            let path = UIBezierPath(roundedRect: bubbleRect, cornerRadius: 11.scale)
            
            let tailPath = UIBezierPath()
            tailPath.move(to: CGPoint(x: bubbleRect.midX - tailSize / 2, y: bubbleRect.maxY))
            tailPath.addLine(to: CGPoint(x: bubbleRect.midX + tailSize / 2, y: bubbleRect.maxY))
            tailPath.addLine(to: CGPoint(x: bubbleRect.midX, y: bubbleRect.maxY + tailSize))
            tailPath.close()

            UIColor.white.setFill()
            path.fill()
            tailPath.fill()
            ctx.cgContext.restoreGState()

            let textOrigin = CGPoint(
                x: bubbleRect.minX + bubbleHPad,
                y: bubbleRect.minY + bubbleVPad
            )
            
            (text as NSString).draw(
                in: CGRect(origin: textOrigin, size: textBounds.size),
                withAttributes: textAttrs.dictionary
            )

            let santaX = (totalW - santaSize.width) / 2.0
            let santaY = bubbleRect.maxY + tailSize
            santa.draw(in: CGRect(x: santaX, y: santaY, width: santaSize.width, height: santaSize.height))
        }
    }
    
    func resize(image: UIImage, to size: CGSize) -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        
        return UIGraphicsImageRenderer(size: size, format: format).image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
