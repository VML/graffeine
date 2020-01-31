import Foundation

public struct GraffeineData: Equatable {
    public var valueMax: Double?
    public var valuesHi: [Double?]
    public var valuesLo: [Double?]
    public var labels: [String?]
    public var selectedLabels: [String?]

    public var selectedIndex: Int?

    public var values: [Double?] {
        get { return valuesHi }
        set { valuesHi = newValue }
    }

    public var highest: Double {
        return valuesHi.map({ $0 ?? 0 }).max() ?? 0
    }

    public var sum: Double {
        return sumHi
    }

    public var sumHi: Double {
        return valuesHi.reduce(Double(0)) { $0 + ($1 ?? 0) }
    }

    public var sumLo: Double {
        return valuesLo.reduce(Double(0)) { $0 + ($1 ?? 0) }
    }

    public var valueMaxOrSum: Double {
        return valueMax ?? sum
    }

    public var valueMaxOrHighest: Double {
        return valueMax ?? highest
    }

    public func loValueOrZero(_ idx: Int) -> Double {
        return (0..<valuesLo.count ~= idx)
            ? valuesLo[idx] ?? 0.0
            : 0.0
    }

    public func preferredLabelValue(_ index: Int) -> String {
        return (index == (selectedIndex ?? Int.max))
            ? selectedLabelValue(self.selectedIndex!)
            : labelValue(index)
    }

    public func labelValue(_ index: Int) -> String {
        return (0..<labels.count ~= index)
            ? labels[index] ?? ""
            : ""
    }

    public func selectedLabelValue(_ index: Int) -> String {
        return (0..<selectedLabels.count ~= index)
            ? selectedLabels[index] ?? ""
            : labelValue(index)
    }

    public init() {
        valueMax = nil
        valuesHi = []
        valuesLo = []
        labels = []
        selectedLabels = []
        selectedIndex = nil
    }

    public init(valueMax: Double?,
                valuesHi: [Double?],
                valuesLo: [Double?],
                labels: [String?],
                selectedLabels: [String?],
                selectedIndex: Int?) {
        self.valueMax = valueMax
        self.valuesHi = valuesHi
        self.valuesLo = valuesLo
        self.labels = labels
        self.selectedLabels = selectedLabels
        self.selectedIndex = selectedIndex
    }
}
