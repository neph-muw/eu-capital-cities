//
//  CityTableViewCell.swift
//  eu-capital-cities
//
//  Created by Roman Mykitchak on 21/08/2020.
//

import UIKit

fileprivate extension UIConfigurationStateCustomKey {
    static let cityKey = UIConfigurationStateCustomKey("com.nostradupus.CityCell.item")
}

private extension UICellConfigurationState {
    var item: EuCity? {
        set { self[.cityKey] = newValue }
        get { return self[.cityKey] as? EuCity }
    }
}

class CityTableViewCell: UITableViewCell {
    
    private var item: EuCity? = nil
    var cityCellDelegate: CityTableViewCellDelegate?
    
    func updateWithItem(_ newItem: EuCity) {
        guard item != newItem else { return }
        item = newItem
        setNeedsUpdateConfiguration()
    }
    
    override var configurationState: UICellConfigurationState {
        var state = super.configurationState
        state.item = self.item
        return state
    }
    
//    private func defaultListContentConfiguration() -> UIListContentConfiguration {
//        return .subtitleCell()
//    }
//    private lazy var listContentView = UIListContentView(configuration: defaultListContentConfiguration())
//    var isConfigured: Bool = false
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
//        configureCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
//    private func configureCell() {
//        guard !isConfigured else { return }
//
//        self.isUserInteractionEnabled = true
//        contentView.addSubview(listContentView)
//    }
    
    override func updateConfiguration(using state: UICellConfigurationState) {
        
//        configureCell()
        
        var content = CityCellConfiguration().updated(for: state)
        content.image = "🏢".image()
        if let item = state.item {
            content.cityName = item.name
            if let data = item.imageData {
                content.image = UIImage(data: data)
            }
            content.favourited = item.favourited
        }
        content.cell = self
        contentConfiguration = content
    }
}

extension CityTableViewCell {
    func wasFavourited(favourited: Bool) {
        debugPrint("TMPLOG favourited \(favourited)")
        guard let city = item else { return }
        cityCellDelegate?.wasFavourited(favourited: favourited, forCell: self, withItem: city)
    }
}

protocol CityTableViewCellDelegate {
    func wasFavourited(favourited: Bool, forCell: CityTableViewCell, withItem: EuCity)
}
