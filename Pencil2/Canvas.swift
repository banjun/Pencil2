import UIKit
import Ikemen

final class Canvas: UIView, UIPencilInteractionDelegate {
    var onTouchesChange: ((UITouch) -> Void)?

    let centerDot = UIView() ※ {
        $0.frame = CGRect(origin: .zero, size: CGSize(width: 32, height: 32))
        $0.isHidden = true
        $0.layer.cornerRadius = 16
        $0.clipsToBounds = true
        $0.backgroundColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
    }

    let azimuthLine = UIView() ※ {
        $0.frame = CGRect(origin: .zero, size: CGSize(width: 320, height: 4))
        $0.isHidden = true
        $0.backgroundColor = #colorLiteral(red: 1, green: 0.1857388616, blue: 0.5733950138, alpha: 1)
    }

    init() {
        super.init(frame: .zero)
        backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)

        addSubview(centerDot)
        addSubview(azimuthLine)

        addInteraction(UIPencilInteraction() ※ {$0.delegate = self})
    }

    required init?(coder aDecoder: NSCoder) {fatalError()}

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let pencilTouch = (touches.first {$0.type == .pencil}) else { return }
        onTouchesChange?(pencilTouch)
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let pencilTouch = (touches.first {$0.type == .pencil}) else { return }
        onTouchesChange?(pencilTouch)

        centerDot.isHidden = false
        centerDot.center = pencilTouch.preciseLocation(in: self)
        let forceScale = (4 * pencilTouch.force + pencilTouch.maximumPossibleForce) / pencilTouch.maximumPossibleForce
        centerDot.transform = CGAffineTransform.identity
            .scaledBy(x: forceScale, y: forceScale)

        azimuthLine.isHidden = false
        azimuthLine.center = centerDot.center
        let altitudeScale = cos(pencilTouch.altitudeAngle)
        azimuthLine.transform = CGAffineTransform.identity
            .rotated(by: pencilTouch.azimuthAngle(in: self))
            .scaledBy(x: altitudeScale, y: 1)
            .translatedBy(x: -azimuthLine.bounds.width / 2, y: 0)
    }

    func pencilInteractionDidTap(_ interaction: UIPencilInteraction) {
        switch UIPencilInteraction.preferredTapAction {
        case .ignore: break
        case .switchEraser:
            NSLog("%@", "Switch Current Tool <-> Eraser")
        case .switchPrevious:
            NSLog("%@", "Switch Current Tool <-> Previous")
        case .showColorPalette:
            NSLog("%@", "Show Color Palette")
        }

        centerDot.transform = CGAffineTransform.identity.scaledBy(x: 0, y: 0)
        UIView.animate(withDuration: 0.8, delay: 0, usingSpringWithDamping: 0.2, initialSpringVelocity: 0, options: [], animations: {self.centerDot.transform = .identity}, completion: {_ in})
    }
}
