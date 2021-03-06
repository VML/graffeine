import UIKit

open class GraffeineHorizontalLabelLayer: GraffeineLayer {

    public var positioner: Positioner = .column
    public var unitText: UnitText = UnitText()

    public var labelRotation: Int = 0
    public var labelPadding = GraffeineLabel.Padding()
    public var labelAlignment = DistributedLabelAlignment(horizontal: .center,
                                                          vertical: .center)

    override open var expectedNumberOfSublayers: Int {
        return self.data.labels.count
    }

    override open func generateSublayer() -> CALayer {
        return Label()
    }

    override open func repositionSublayers(animator: GraffeineDataAnimating? = nil) {
        guard let sublayers = self.sublayers, (!sublayers.isEmpty) else { return }
        let numberOfUnits = data.labels.count

        for (index, label) in sublayers.enumerated() {
            guard let label = label as? Label, index < numberOfUnits else { continue }

            label.unitColumn = unitColumn
            label.padding = labelPadding
            label.alignment = labelAlignment.graffeineLabelAlignment(for: index, count: numberOfUnits)
            label.labelRotation = labelRotation

            unitFill.apply(to: label, index: index)
            unitLine.apply(to: label, index: index)
            unitText.apply(to: label, index: index)
            unitShadow.apply(to: label)
            unitAnimation.perpetual.apply(to: label)

            applySelectionState(label, index: index)

            positioner.get().reposition(label: label,
                                        for: index,
                                        in: data.labels,
                                        containerSize: bounds.size)
        }
    }

    override public init() {
        super.init()
    }

    public convenience init(id: AnyHashable, height: CGFloat, region: Region = .bottomGutter) {
        self.init()
        self.id = id
        self.region = region
        self.frame = CGRect(x: 0, y: 0, width: 100, height: height)
    }

    required public init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override public init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? Self {
            self.unitText = layer.unitText
            self.labelRotation = layer.labelRotation
            self.labelPadding = layer.labelPadding
            self.labelAlignment = layer.labelAlignment
            self.positioner = layer.positioner
        }
    }

    @discardableResult
    override open func apply(_ conf: (GraffeineHorizontalLabelLayer) -> ()) -> GraffeineHorizontalLabelLayer {
        conf(self)
        return self
    }
}
