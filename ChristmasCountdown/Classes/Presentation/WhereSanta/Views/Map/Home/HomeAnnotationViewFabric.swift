//
//  HomeAnnotationViewFabric.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 16.10.2025.
//

import UIKit
import MapKit

final class HomeAnnotationViewFabric {
    enum Constants {
        static let id = "home_id"
    }
}

// MARK: Public
extension HomeAnnotationViewFabric {
    func make(mapView: MKMapView, annotation: HomeAnnotation) -> MKAnnotationView {
        let img = composeImage(with: annotation.text)
        let view = mapView.dequeueReusableAnnotationView(withIdentifier: Constants.id)
            ?? MKAnnotationView(annotation: annotation, reuseIdentifier: Constants.id)
        view.annotation = annotation
        view.image = img
        view.centerOffset = CGPoint(x: 0, y: -img.size.height / 2)
        return view
    }
}

// MARK: Private
private extension HomeAnnotationViewFabric {
    func composeImage(with text: String) -> UIImage {
        let homeSize = CGSize(width: 66.scale, height: 95.scale)
        let home = resize(image: UIImage(named: "WhereSanta.Annotation.Home")!, to: homeSize)

        let attrs = TextAttributes()
            .textColor(.black)
            .font(Fonts.NewYork.mediumBold(size: 17.scale))

        let bounds = (text as NSString).boundingRect(
            with: CGSize(width: 180.scale, height: .greatestFiniteMagnitude),
            options: [.usesLineFragmentOrigin, .usesFontLeading],
            attributes: attrs.dictionary, context: nil
        ).integral

        let hPad: CGFloat = 16.scale
        let vPad: CGFloat = 12.scale
        let tail: CGFloat = 14.scale
        let bubble = CGSize(
            width: bounds.width + hPad * 2,
            height: bounds.height + vPad * 2
        )
        let totalW = max(bubble.width, homeSize.width)
        let totalH = bubble.height + tail + homeSize.height

        let fmt = UIGraphicsImageRendererFormat()
        fmt.scale = UIScreen.main.scale

        return UIGraphicsImageRenderer(size: CGSize(width: totalW, height: totalH), format: fmt).image { ctx in
            let bubbleX = (totalW - bubble.width) / 2
            let bubbleRect = CGRect(x: bubbleX, y: 0, width: bubble.width, height: bubble.height)

            let path = UIBezierPath(roundedRect: bubbleRect, cornerRadius: 11.scale)

            let tailPath = UIBezierPath()
            tailPath.move(to: CGPoint(x: bubbleRect.midX - tail / 2, y: bubbleRect.maxY))
            tailPath.addLine(to: CGPoint(x: bubbleRect.midX + tail / 2, y: bubbleRect.maxY))
            tailPath.addLine(to: CGPoint(x: bubbleRect.midX, y: bubbleRect.maxY + tail))
            tailPath.close()

            UIColor.white.setFill()
            path.fill()
            tailPath.fill()
            ctx.cgContext.restoreGState()

            (text as NSString).draw(
                in: CGRect(x: bubbleRect.minX + hPad, y: bubbleRect.minY + vPad, width: bounds.width, height: bounds.height),
                withAttributes: attrs.dictionary
            )

            let homeX = (totalW - homeSize.width) / 2
            home.draw(in: CGRect(x: homeX, y: bubbleRect.maxY + tail, width: homeSize.width, height: homeSize.height))
        }
    }

    func resize(image: UIImage, to size: CGSize) -> UIImage {
        let fmt = UIGraphicsImageRendererFormat()
        fmt.scale = UIScreen.main.scale
        return UIGraphicsImageRenderer(size: size, format: fmt).image { _ in
            image.draw(in: CGRect(origin: .zero, size: size))
        }
    }
}
