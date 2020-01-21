import UIKit

open class GraffeinePieLayer: GraffeineLayer {

    public var clockwise: Bool = true
    public var rotation: UInt = 0
    public var diameter: GraffeineLayer.DimensionalUnit = .percentage(0.9)
    public var holeDiameter: GraffeineLayer.DimensionalUnit = .explicit(0.0)

    public var borderColors: [UIColor] = []
    public var borderThickness: CGFloat = 0.0
    public var borderDashPattern: [NSNumber]? = nil
    public var borderDashPhase: CGFloat = 0

    override open func generateSublayer() -> CALayer {
        return PieSlice()
    }

    override open func repositionSublayers(animator: GraffeineDataAnimating? = nil) {
        guard let sublayers = self.sublayers, (!sublayers.isEmpty) else { return }
        let centerPoint = CGPoint(x: bounds.size.width / 2, y: bounds.size.height / 2)
        let numberOfSlices = data.values.count
        let total = data.valueMaxOrSum
        let percentages = data.values.map { CGFloat( ($0 ?? 0) / total ) }
        let radius = resolveRadius(diameter)
        let holeRadius = resolveRadius(holeDiameter)

        for (index, slice) in sublayers.enumerated() {
            guard let slice = slice as? PieSlice, index < numberOfSlices else { continue }
            slice.clockwise = clockwise
            slice.rotation = rotation
            slice.radius = radius
            slice.holeRadius = holeRadius
            slice.frame = self.bounds
            slice.fillColor = safeIndexedColor(index)
            slice.strokeColor = safeIndexedBorderColor(index)
            slice.lineWidth = borderThickness
            slice.lineDashPattern = borderDashPattern
            slice.lineDashPhase = borderDashPhase
            unitShadow.apply(to: slice)

            if (data.selectedIndex == index) {
                if let color = selection.fill.color { slice.fillColor = color.cgColor }
                if let color = selection.line.color { slice.fillColor = color.cgColor }
                if let selectedDiameter = selection.radial.diameter {
                    let selectedRadius = resolveRadius(selectedDiameter)
                    let radDelta = selectedRadius - radius
                    slice.radius = radius + radDelta
                    slice.holeRadius = holeRadius + radDelta
                }
            }

            slice.reposition(for: index,
                             in: percentages,
                             centerPoint: centerPoint,
                             animator: animator as? GraffeinePieDataAnimating)
        }
    }

    private func resolveRadius(_ diameter: GraffeineLayer.DimensionalUnit) -> CGFloat {
        let diameterBounds = min(bounds.size.width, bounds.size.height)
        let realDiameter = diameter.resolved(within: diameterBounds)
        return (realDiameter / 2)
    }

    open func safeIndexedBorderColor(_ idx: Int) -> CGColor {
        return safeIndexedColor(idx, colors: self.borderColors)
    }

    override public init() {
        super.init()
        self.contentsScale = UIScreen.main.scale
    }

    public convenience init(id: AnyHashable, region: Region = .main) {
        self.init()
        self.id = id
        self.region = region
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    override public init(layer: Any) {
        super.init(layer: layer)
        if let layer = layer as? Self {
            self.clockwise = layer.clockwise
            self.rotation = layer.rotation
            self.diameter = layer.diameter
            self.holeDiameter = layer.holeDiameter
            self.borderColors = layer.borderColors
            self.borderThickness = layer.borderThickness
            self.borderDashPattern = layer.borderDashPattern
            self.borderDashPhase = layer.borderDashPhase
        }
    }

    @discardableResult
    override open func apply(_ conf: (GraffeinePieLayer) -> ()) -> GraffeinePieLayer {
        conf(self)
        return self
    }
}
