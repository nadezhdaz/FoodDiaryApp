//
//  SettingsViewController.swift
//  TakeEatEasy
//
//  Created by Nadezhda Zenkova on 04.11.2021.
//

import UIKit

class SettingsViewController: UIViewController, SettingsViewModelViewDelegate {

    @IBOutlet weak var settingsTableView: UITableView!
    
    var viewModel: SettingsViewModelType!
    
    // MARK: - UIViewController interface
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.viewDelegate = self
        view.backgroundColor = UIColor.secondaryBackground
        setupTableView()
        navigationController?.navigationBar.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        //settingsTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    func changeSchemeTo(_ scheme: Colors){
        UIColor.initWithColorScheme(scheme)
        view.setNeedsDisplay()
        for subview in self.view.subviews{
            subview.setNeedsDisplay()
        }
    }
    
    private func setupTableView() {
        settingsTableView.translatesAutoresizingMaskIntoConstraints = false
        settingsTableView.backgroundColor = UIColor.secondaryBackground
        settingsTableView.delegate = self
        settingsTableView.dataSource = self
        settingsTableView.register(UINib(nibName: NumberSettingsTableViewCell.cellId, bundle: nil), forCellReuseIdentifier: NumberSettingsTableViewCell.cellId)
        settingsTableView.register(UINib(nibName: ColorSettingsTableViewCell.cellId, bundle: nil), forCellReuseIdentifier: ColorSettingsTableViewCell.cellId)
        settingsTableView.showsVerticalScrollIndicator = false
        settingsTableView.contentInsetAdjustmentBehavior = .always
        settingsTableView.layer.cornerRadius = 15
    }
    
    func updateScreen(with scheme: Colors) {
        DispatchQueue.main.async {
            self.settingsTableView.reloadData()
            self.changeSchemeTo(scheme)
            self.view.setNeedsDisplay()
            self.view.layoutIfNeeded()
        }
    }
    
    func updateScreen() {
        
    }

}

// MARK: - UITableViewDataSource

extension SettingsViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfItems()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {        
        switch viewModel.itemFor(row: indexPath.row) {
        case .accuracy:
            guard let cell = settingsTableView.dequeueReusableCell(withIdentifier: NumberSettingsTableViewCell.cellId, for: indexPath) as? NumberSettingsTableViewCell else { return UITableViewCell() }
            cell.setupNumber(viewModel.currentAccuracy)
            cell.accuracyButtonTapHandler = { [weak self] number in
                self?.viewModel.setupAccuracy(number)
            }
            return cell
        case .colorTheme:
            guard let cell = settingsTableView.dequeueReusableCell(withIdentifier: ColorSettingsTableViewCell.cellId, for: indexPath) as? ColorSettingsTableViewCell else { return UITableViewCell() }
            cell.setupCurrentColor(viewModel.currentColorTheme)
            cell.colorButtonsTapHandler = { [weak self] name in
                self?.viewModel.setupColorTheme(name)
            }
            return cell
        }
    }
    
    @objc func switchDrawing(_ sender: UISwitch) {
        //toggleAnimation(isOn: sender.isOn)
    }
}


extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if cell.isKind(of: ColorSettingsTableViewCell.self) {
            
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        /*switch SettingsType.allCases[indexPath.row] {
        case .accuracy:
            break
        case .colorTheme:
            break
        }*/
        
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
