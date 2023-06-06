import PureLayout

extension UIView {
    func addBottomBorder(color: UIColor, thickness: CGFloat) {
        let borderLayer = CALayer()
        borderLayer.backgroundColor = color.cgColor
        borderLayer.frame = CGRect(x: 0, y: frame.height - thickness, width: frame.width, height: thickness)
        layer.addSublayer(borderLayer)
    }
}
