//
//  QRCodesViewController.swift
//  qrcode-reader
//
//  Created by Shofia Ghazali on 29/10/26.
//

import UIKit

class QRCodesViewController: UIViewController {
    
    private var collectionView: UICollectionView!
    
    //MARK: create headerView
    private let headerView = UIView()
    private let titleLabel = UILabel()
    private let scanButton = UIButton(type: .system)
    
    private let tabsView = UIView()
    private let gridButton = UIButton(type: .system)
    private let listButton = UIButton(type: .system)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpUI()
        setUpLayout()
    }
    
    private func setUpUI(){
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        gridButton.translatesAutoresizingMaskIntoConstraints = false
        listButton.translatesAutoresizingMaskIntoConstraints = false
        tabsView.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(headerView)
        view.addSubview(tabsView)
        

        tabsView.addSubview(gridButton)
        tabsView.addSubview(listButton)
        
        gridButton.addTarget(
            self,
            action: #selector(showGrid),
            for: .touchUpInside
        )

        listButton.addTarget(
            self,
            action: #selector(showList),
            for: .touchUpInside
        )
        
        setUpHeaderView()
        setUpTabs()
    }
    
    private func setUpLayout(){
        
        // Constraints
        NSLayoutConstraint.activate([
            headerView.topAnchor.constraint(
                equalTo: view.safeAreaLayoutGuide.topAnchor,
                constant: 16
            ),
            headerView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 20
            ),
            headerView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -20
            ),
            headerView.heightAnchor.constraint(equalToConstant: 50),
            
            titleLabel.leadingAnchor.constraint(
                equalTo: headerView.leadingAnchor
            ),
            titleLabel.centerYAnchor.constraint(
                equalTo: headerView.centerYAnchor
            ),
            
            scanButton.trailingAnchor.constraint(
                equalTo: headerView.trailingAnchor
            ),
            scanButton.centerYAnchor.constraint(
                equalTo: headerView.centerYAnchor
            ),
            scanButton.heightAnchor.constraint(equalToConstant: 44),
            
            // Tabs container
            tabsView.topAnchor.constraint(
                equalTo: headerView.bottomAnchor,
                constant: 24
            ),
            tabsView.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 20
            ),
            tabsView.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -20
            ),
            tabsView.heightAnchor.constraint(equalToConstant: 44),

            // Grid button
            gridButton.leadingAnchor.constraint(
                equalTo: tabsView.leadingAnchor
            ),
            gridButton.topAnchor.constraint(
                equalTo: tabsView.topAnchor
            ),
            gridButton.bottomAnchor.constraint(
                equalTo: tabsView.bottomAnchor
            ),
            gridButton.trailingAnchor.constraint(
                equalTo: tabsView.centerXAnchor,
                constant: -6
            ),

            // List button
            listButton.leadingAnchor.constraint(
                equalTo: tabsView.centerXAnchor,
                constant: 6
            ),
            listButton.trailingAnchor.constraint(
                equalTo: tabsView.trailingAnchor
            ),
            listButton.topAnchor.constraint(
                equalTo: tabsView.topAnchor
            ),
            listButton.bottomAnchor.constraint(
                equalTo: tabsView.bottomAnchor
            )
        ])
    }
    
    private func setUpHeaderView() {
        // Title
        titleLabel.text = "QRCode"
        titleLabel.font = .boldSystemFont(ofSize: 28)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(titleLabel)
        
        // Scan button
        scanButton.setTitle("Scan", for: .normal)
        scanButton.setImage(
            UIImage(systemName: "qrcode.viewfinder"),
            for: .normal
        )
        scanButton.tintColor = .white
        scanButton.setTitleColor(.white, for: .normal)
        scanButton.backgroundColor = .systemBlue
        scanButton.layer.cornerRadius = 10
        scanButton.configuration = .plain()
        scanButton.configuration?.image = UIImage(
            systemName: "qrcode.viewfinder"
        )
        scanButton.configuration?.title = "Scan"
        scanButton.configuration?.imagePadding = 8
        scanButton.configuration?.baseForegroundColor = .white
        scanButton.translatesAutoresizingMaskIntoConstraints = false
        headerView.addSubview(scanButton)
    }
    
    private func setUpTabs() {
        gridButton.setTitle("Grid", for: .normal)
        listButton.setTitle("List", for: .normal)

        gridButton.backgroundColor = .systemBlue
        gridButton.setTitleColor(.white, for: .normal)

        listButton.backgroundColor = .secondarySystemBackground
        listButton.setTitleColor(.label, for: .normal)

        gridButton.layer.cornerRadius = 10
        listButton.layer.cornerRadius = 10
    }
    
    @objc private func showGrid() {
        updateTabSelection(isGrid: true)
    }

    @objc private func showList() {
        updateTabSelection(isGrid: false)
    }
    
    private func updateTabSelection(isGrid: Bool) {
        // Grid appearance
        gridButton.backgroundColor = isGrid
            ? .systemBlue
            : .secondarySystemBackground

        gridButton.setTitleColor(
            isGrid ? .white : .label,
            for: .normal
        )

        // List appearance
        listButton.backgroundColor = isGrid
            ? .secondarySystemBackground
            : .systemBlue

        listButton.setTitleColor(
            isGrid ? .label : .white,
            for: .normal
        )
    }
}


#Preview {
    QRCodesViewController()
}

