import AppKit

@MainActor
final class KiwiPetView: NSView {
    enum Motion {
        case walking
        case jumping
        case foraging
        case dancing
    }

    enum Action {
        case play
        case dismiss
    }

    var onAction: ((Action) -> Void)?
    var message = ReminderMessages.randomRest() {
        didSet { needsDisplay = true }
    }
    var animationPhase: CGFloat = 0 {
        didSet { needsDisplay = true }
    }
    var motion: Motion = .walking {
        didSet { needsDisplay = true }
    }
    var actionProgress: CGFloat = 0 {
        didSet { needsDisplay = true }
    }
    var facingRight = true {
        didSet { needsDisplay = true }
    }

    private let bubbleRect = NSRect(x: 14, y: 116, width: 332, height: 130)
    private let playRect = NSRect(x: 179, y: 126, width: 102, height: 26)
    private let closeRect = NSRect(x: 302, y: 210, width: 28, height: 28)

    override var isFlipped: Bool { false }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        NSGraphicsContext.current?.imageInterpolation = .high
        drawBubble()
        drawKiwi()
    }

    override func mouseDown(with event: NSEvent) {
        let point = convert(event.locationInWindow, from: nil)
        if closeRect.contains(point) {
            onAction?(.dismiss)
        } else if playRect.contains(point) || NSRect(x: 80, y: 12, width: 205, height: 104).contains(point) {
            onAction?(.play)
        }
    }

    private func drawBubble() {
        NSGraphicsContext.saveGraphicsState()
        let shadow = NSShadow()
        shadow.shadowColor = NSColor.black.withAlphaComponent(0.18)
        shadow.shadowBlurRadius = 14
        shadow.shadowOffset = NSSize(width: 0, height: -4)
        shadow.set()

        let bubble = NSBezierPath(roundedRect: bubbleRect, xRadius: 22, yRadius: 22)
        NSColor(calibratedWhite: 1, alpha: 0.96).setFill()
        bubble.fill()

        let tail = NSBezierPath()
        tail.move(to: NSPoint(x: 95, y: 119))
        tail.line(to: NSPoint(x: 111, y: 96))
        tail.line(to: NSPoint(x: 127, y: 119))
        tail.close()
        tail.fill()

        NSGraphicsContext.restoreGraphicsState()

        let englishStyle: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 15, weight: .semibold),
            .foregroundColor: NSColor(calibratedRed: 0.10, green: 0.25, blue: 0.20, alpha: 1)
        ]
        let maoriStyle: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 12.5, weight: .regular),
            .foregroundColor: NSColor(calibratedRed: 0.30, green: 0.38, blue: 0.34, alpha: 1)
        ]
        message.english.draw(
            in: NSRect(x: 34, y: 174, width: 254, height: 46),
            withAttributes: englishStyle
        )
        message.maori.draw(
            in: NSRect(x: 34, y: 150, width: 282, height: 34),
            withAttributes: maoriStyle
        )

        let playPath = NSBezierPath(roundedRect: playRect, xRadius: 13, yRadius: 13)
        NSColor(calibratedRed: 0.20, green: 0.48, blue: 0.35, alpha: 1).setFill()
        playPath.fill()
        let playText = "Tākaro · Play"
        let playAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 11.5, weight: .semibold),
            .foregroundColor: NSColor.white
        ]
        let playSize = playText.size(withAttributes: playAttributes)
        playText.draw(
            at: NSPoint(x: playRect.midX - playSize.width / 2, y: playRect.midY - playSize.height / 2),
            withAttributes: playAttributes
        )

        let closeCircle = NSBezierPath(ovalIn: closeRect)
        NSColor(calibratedWhite: 0.92, alpha: 1).setFill()
        closeCircle.fill()
        let closeText = "×"
        let closeAttributes: [NSAttributedString.Key: Any] = [
            .font: NSFont.systemFont(ofSize: 18, weight: .medium),
            .foregroundColor: NSColor(calibratedWhite: 0.32, alpha: 1)
        ]
        let closeSize = closeText.size(withAttributes: closeAttributes)
        closeText.draw(
            at: NSPoint(x: closeRect.midX - closeSize.width / 2, y: closeRect.midY - closeSize.height / 2 + 1),
            withAttributes: closeAttributes
        )
    }

    private func drawKiwi() {
        if motion == .foraging {
            drawForagingScene()
        }

        NSGraphicsContext.saveGraphicsState()
        let bob: CGFloat
        let rotation: CGFloat
        switch motion {
        case .walking:
            bob = abs(sin(animationPhase)) * 3
            rotation = 0
        case .jumping:
            bob = abs(sin(animationPhase * 1.15)) * 23
            rotation = sin(animationPhase * 1.15) * 0.055
        case .foraging:
            bob = 0
            rotation = -0.17 - abs(sin(animationPhase * 2.7)) * 0.26
        case .dancing:
            bob = abs(sin(animationPhase * 2)) * 13
            rotation = sin(animationPhase * 1.5) * 0.18
        }
        let transform = NSAffineTransform()
        transform.translateX(by: 174, yBy: 57 + bob)
        transform.rotate(byRadians: rotation)
        transform.scaleX(by: facingRight ? 1 : -1, yBy: 1)
        transform.translateX(by: -174, yBy: -57)
        transform.concat()

        // Ground shadow
        let ground = NSBezierPath(ovalIn: NSRect(x: 95, y: 17 - bob, width: 154, height: 17))
        NSColor.black.withAlphaComponent(0.14).setFill()
        ground.fill()

        // Legs alternate while walking.
        let step: CGFloat
        switch motion {
        case .walking: step = sin(animationPhase) * 7
        case .jumping: step = sin(animationPhase * 1.15) * 4
        case .foraging: step = 0
        case .dancing: step = sin(animationPhase * 2) * 8
        }
        drawLeg(from: NSPoint(x: 152, y: 37), offset: step)
        drawLeg(from: NSPoint(x: 192, y: 37), offset: -step)

        // Body
        let body = NSBezierPath(ovalIn: NSRect(x: 105, y: 34, width: 137, height: 82))
        let bodyGradient = NSGradient(colors: [
            NSColor(calibratedRed: 0.36, green: 0.27, blue: 0.16, alpha: 1),
            NSColor(calibratedRed: 0.18, green: 0.13, blue: 0.08, alpha: 1)
        ])
        bodyGradient?.draw(in: body, angle: -70)

        // Feather strokes
        NSColor(calibratedRed: 0.62, green: 0.48, blue: 0.29, alpha: 0.55).setStroke()
        for index in 0..<8 {
            let x = 128 + CGFloat(index) * 12
            let feather = NSBezierPath()
            feather.lineWidth = 2
            feather.move(to: NSPoint(x: x, y: 56 + CGFloat(index % 2) * 9))
            feather.curve(
                to: NSPoint(x: x + 16, y: 91 + CGFloat(index % 3) * 3),
                controlPoint1: NSPoint(x: x - 5, y: 73),
                controlPoint2: NSPoint(x: x + 8, y: 85)
            )
            feather.stroke()
        }

        // Beak
        let beak = NSBezierPath()
        beak.move(to: NSPoint(x: 222, y: 91))
        beak.curve(
            to: NSPoint(x: 314, y: 70),
            controlPoint1: NSPoint(x: 253, y: 93),
            controlPoint2: NSPoint(x: 284, y: 81)
        )
        beak.curve(
            to: NSPoint(x: 222, y: 82),
            controlPoint1: NSPoint(x: 278, y: 71),
            controlPoint2: NSPoint(x: 249, y: 78)
        )
        beak.close()
        NSColor(calibratedRed: 0.82, green: 0.65, blue: 0.32, alpha: 1).setFill()
        beak.fill()

        // Eye and catchlight
        NSColor(calibratedWhite: 0.04, alpha: 1).setFill()
        NSBezierPath(ovalIn: NSRect(x: 211, y: 92, width: 13, height: 13)).fill()
        NSColor.white.setFill()
        NSBezierPath(ovalIn: NSRect(x: 215, y: 98, width: 4, height: 4)).fill()

        // Rosy cheek during energetic actions.
        if motion == .dancing || motion == .jumping {
            NSColor(calibratedRed: 0.94, green: 0.48, blue: 0.45, alpha: 0.55).setFill()
            NSBezierPath(ovalIn: NSRect(x: 207, y: 75, width: 18, height: 9)).fill()
        }
        NSGraphicsContext.restoreGraphicsState()
    }

    private func drawForagingScene() {
        let wormX: CGFloat = facingRight ? 294 : 66
        let wiggle = sin(animationPhase * 3.4) * 4

        // The worm vanishes near the end of the sequence: snack acquired.
        if actionProgress < 0.70 {
            let worm = NSBezierPath()
            worm.lineWidth = 5
            worm.lineCapStyle = .round
            worm.move(to: NSPoint(x: wormX - 12, y: 25))
            worm.curve(
                to: NSPoint(x: wormX + 14, y: 24),
                controlPoint1: NSPoint(x: wormX - 5, y: 34 + wiggle),
                controlPoint2: NSPoint(x: wormX + 6, y: 15 - wiggle)
            )
            NSColor(calibratedRed: 0.78, green: 0.31, blue: 0.28, alpha: 1).setStroke()
            worm.stroke()

            NSColor(calibratedWhite: 0.10, alpha: 1).setFill()
            NSBezierPath(ovalIn: NSRect(x: wormX + 11, y: 24, width: 2.8, height: 2.8)).fill()
        } else {
            // A tiny sparkle punctuates the successful bite.
            let sparkle = NSBezierPath()
            sparkle.lineWidth = 2
            sparkle.move(to: NSPoint(x: wormX, y: 18))
            sparkle.line(to: NSPoint(x: wormX, y: 34))
            sparkle.move(to: NSPoint(x: wormX - 8, y: 26))
            sparkle.line(to: NSPoint(x: wormX + 8, y: 26))
            NSColor(calibratedRed: 0.95, green: 0.72, blue: 0.18, alpha: 0.9).setStroke()
            sparkle.stroke()
        }

        // Dirt flicks appear as the beak pecks the ground.
        if abs(sin(animationPhase * 2.7)) > 0.72 && actionProgress < 0.72 {
            let dirtColor = NSColor(calibratedRed: 0.45, green: 0.31, blue: 0.16, alpha: 0.72)
            dirtColor.setFill()
            for (dx, dy, size) in [(-13.0, 8.0, 4.0), (0.0, 12.0, 3.0), (12.0, 7.0, 3.5)] {
                NSBezierPath(ovalIn: NSRect(
                    x: wormX + CGFloat(dx),
                    y: 22 + CGFloat(dy),
                    width: CGFloat(size),
                    height: CGFloat(size)
                )).fill()
            }
        }

        let scratch = NSBezierPath()
        scratch.lineWidth = 1.5
        scratch.lineCapStyle = .round
        for offset in stride(from: -18.0, through: 18.0, by: 12.0) {
            scratch.move(to: NSPoint(x: wormX + CGFloat(offset) - 4, y: 18))
            scratch.line(to: NSPoint(x: wormX + CGFloat(offset) + 4, y: 16))
        }
        NSColor(calibratedRed: 0.42, green: 0.31, blue: 0.19, alpha: 0.48).setStroke()
        scratch.stroke()
    }

    private func drawLeg(from start: NSPoint, offset: CGFloat) {
        let leg = NSBezierPath()
        leg.lineCapStyle = .round
        leg.lineJoinStyle = .round
        leg.lineWidth = 4
        leg.move(to: start)
        leg.line(to: NSPoint(x: start.x + offset, y: 24))
        leg.line(to: NSPoint(x: start.x - 7 + offset, y: 19))
        leg.move(to: NSPoint(x: start.x + offset, y: 24))
        leg.line(to: NSPoint(x: start.x + 9 + offset, y: 20))
        NSColor(calibratedRed: 0.68, green: 0.48, blue: 0.20, alpha: 1).setStroke()
        leg.stroke()
    }
}
