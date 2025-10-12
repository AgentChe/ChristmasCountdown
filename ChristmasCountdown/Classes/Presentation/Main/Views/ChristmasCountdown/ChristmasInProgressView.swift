//
//  ChristmasInProgressView.swift
//  ChristmasCountdown
//
//  Created by Андрей Чернышев on 24.12.2025.
//

import UIKit

final class ChristmasInProgressView: UIView {
    private let trackLayer = CAShapeLayer()
    private let progressLayer = CAShapeLayer()

    private let santaView: UIImageView = {
        let iv = UIImageView(image: UIImage(named: "Main.Santa"))
        iv.contentMode = .scaleAspectFit
        iv.isHidden = false
        return iv
    }()

    private let lineWidth: CGFloat = 20.scale
    private let trackColor = UIColor.white.withAlphaComponent(0.25)
    private let progressColor = UIColor.white

    private var arcCenter: CGPoint = .zero
    private var radius: CGFloat = 0

    private var progress: CGFloat = 0
    private var lastHoursBucket: Int?
    private var lastTarget: Date?

    override init(frame: CGRect) {
        super.init(frame: frame)

        clipsToBounds = false
        isUserInteractionEnabled = false

        layer.addSublayer(trackLayer)
        layer.addSublayer(progressLayer)
        addSubview(santaView)
        santaView.layer.zPosition = 10

        trackLayer.fillColor = UIColor.clear.cgColor
        trackLayer.strokeColor = trackColor.cgColor
        trackLayer.lineWidth = lineWidth
        trackLayer.lineCap = .round

        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.strokeColor = progressColor.cgColor
        progressLayer.lineWidth = lineWidth
        progressLayer.lineCap = .round
        progressLayer.strokeEnd = 0
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        
        layoutArc()
        positionSanta()
        bringSubviewToFront(santaView)
    }
}

// MARK: Public
extension ChristmasInProgressView {
    func setup(christmasCountdown: ChristmasCountdownManager.Snapshot) {
        let now = Date()
        let target = christmasCountdown.target

        if lastTarget != target {
            lastTarget = target
            lastHoursBucket = nil
        }

        if christmasCountdown.isChristmas {
            updateProgress(1, animated: true)
            lastHoursBucket = 0
            return
        }

        let remainingSec = max(0, target.timeIntervalSince(now))
        let hoursBucket = Int(remainingSec / 3600.0)
        guard lastHoursBucket != hoursBucket else { return }
        lastHoursBucket = hoursBucket

        let cal = Calendar.autoupdatingCurrent
        let prev = cal.date(byAdding: .year, value: -1, to: target) ?? target.addingTimeInterval(-31536000)
        let total = max(1, target.timeIntervalSince(prev))
        let passed = max(0, min(total, now.timeIntervalSince(prev)))
        let progress = CGFloat(passed / total)

        updateProgress(progress, animated: true)
    }
}

// MARK: - Private
private extension ChristmasInProgressView {
    func layoutArc() {
        let inset = lineWidth / 2
        let w = bounds.width - inset * 2
        let h = bounds.height - inset * 2

        radius = min(w / 2, h)
        arcCenter = CGPoint(x: bounds.midX, y: bounds.maxY - inset)

        let path = UIBezierPath(
            arcCenter: arcCenter,
            radius: radius,
            startAngle: .pi,
            endAngle: 0,
            clockwise: true
        )

        trackLayer.path = path.cgPath
        progressLayer.path = path.cgPath
        trackLayer.frame = bounds
        progressLayer.frame = bounds
    }

    func updateProgress(_ value: CGFloat, animated: Bool) {
        let clamped = max(0, min(1, value))
        
        if animated {
            let anim = CABasicAnimation(keyPath: "strokeEnd")
            anim.fromValue = progressLayer.presentation()?.strokeEnd ?? progressLayer.strokeEnd
            anim.toValue = clamped
            anim.duration = 0.25
            anim.timingFunction = CAMediaTimingFunction(name: .easeInEaseOut)
            progressLayer.add(anim, forKey: "strokeEnd")
        }
        
        progress = clamped
        progressLayer.strokeEnd = clamped
        positionSanta()
    }

    func positionSanta() {
        guard radius > 0 else { return }
        
        let t = progress
        let angle = .pi * (1 - t)
        let x = arcCenter.x + radius * cos(angle)
        let y = arcCenter.y - radius * sin(angle)
        
        let height = 66.scale
        santaView.bounds.size = CGSize(width: 60.scale, height: height)
        let yOffset = height * 0.15
        santaView.center = CGPoint(x: x, y: y - yOffset)
    }
}
