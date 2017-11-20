//
//  PresetsCategoriesController.swift
//  SynthUISpike
//
//  Created by Matthew Fecher on 9/2/17.
//  Copyright © 2017 Matthew Fecher. All rights reserved.
//

import UIKit

// ******************************************************
// MARK: - Preset Category Enum
// ******************************************************

enum PresetCategory: Int {
    case all
    case arp
    case poly
    case pad
    case lead
    case bass
    case pluck
    
    static let numCategories = 6
 
    func description() -> String {
        switch self {
        case .all: return "All"
        case .arp: return "Arp/Seq"
        case .poly: return "Poly"
        case .pad: return "Pad"
        case .lead: return "Lead"
        case .bass: return "Bass"
        case .pluck: return "Pluck"
        }
    }
}


protocol CategoryDelegate {
    func categoryDidChange(_ newCategoryIndex: Int)
    func userPresetsShare()
}

// ******************************************************
// MARK: - PresetsCategoriesController
// ******************************************************

class PresetsCategoriesController: UIViewController {
    
    @IBOutlet weak var categoryTableView: UITableView!
    var categoryDelegate: CategoryDelegate?
    
    var choices: [Int: String] = [:] {
        didSet {
            categoryTableView.reloadData()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        categoryTableView.separatorColor = #colorLiteral(red: 0.3058823529, green: 0.3058823529, blue: 0.3254901961, alpha: 1)
        
        // first add PresetCategories to table
        for i in 0...PresetCategory.numCategories {
            choices[i] = PresetCategory(rawValue: i)?.description()
        }
        
        // Add Favorites bank
        choices[PresetCategory.numCategories + 1] = "Favorites"
        // Add User bank
        choices[PresetCategory.numCategories + 2] = "User"
       
    }
    
    override func viewDidAppear(_ animated: Bool) {
        guard let presetsControler = parent! as? PresetsViewController else { return }
        categoryDelegate = presetsControler
    }
    
}

// *****************************************************************
// MARK: - TableViewDataSource
// *****************************************************************

extension PresetsCategoriesController: UITableViewDataSource {
    
    func numberOfSections(in categoryTableView: UITableView) -> Int {
        return 1
    }
    
    @objc(tableView:heightForRowAtIndexPath:) func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 44
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if choices.isEmpty {
            return 1
        } else {
            return choices.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        // Get current category
        guard let category = choices[(indexPath as NSIndexPath).row] else { return CategoryCell() }
        
        if let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell") as? CategoryCell {
            
            // Cell updated in CategoryCell.swift
            cell.delegate = self
            cell.configureCell(category: category)
            return cell
            
        } else {
            return CategoryCell() 
        }
    }
    
}

//*****************************************************************
// MARK: - TableViewDelegate
//*****************************************************************

extension PresetsCategoriesController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        // Update category
        categoryDelegate?.categoryDidChange((indexPath as NSIndexPath).row)
    }
    
}

// Pass the share button call up to PresetsView Controller
extension PresetsCategoriesController: CategoryCellDelegate {
    func userPresetsShare() {
        categoryDelegate?.userPresetsShare()
    }
}