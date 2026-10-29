//
//  QRCodesViewController.swift
//  qrcode-reader
//
//  Created by Shofia Ghazali on 29/10/26.
//


import UIKit
import QRScanner
import AVFoundation

class QRCodesViewController: UIViewController, UICollectionViewDelegate {
    

    private var items: [QRCodeItem] = [
        QRCodeItem(text: "https://www.apple.com", date: .now),
        QRCodeItem(text: "WIFI:T:WPA;S:MyNetwork;P:password123;;", date: .now.addingTimeInterval(-3600)),
        QRCodeItem(text: "mailto:hello@example.com", date: .now.addingTimeInterval(-7200)),
        QRCodeItem(text: "tel:+1234567890", date: .now.addingTimeInterval(-10800))
    ]
    
    private var collectionView: UICollectionView!
    
    //MARK: create headerView
    private let headerView = UIView()
    private let titleLabel = UILabel()
    private let scanButton = UIButton(type: .system)
    
    private let segmentedControl = UISegmentedControl(
        items: ["Grid", "List"]
    )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        setUpUI()
        setUpLayout()
    }
    
    private func setUpUI(){
        
        let layout = UICollectionViewFlowLayout()
//        layout.itemSize = CGSize(width: 100, height: 100)
        layout.minimumLineSpacing = 10
        layout.minimumInteritemSpacing = 10
        layout.scrollDirection = .vertical
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        
        //register cell
        collectionView.register(QRCodeCell.self, forCellWithReuseIdentifier: QRCodeCell.reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        
        headerView.translatesAutoresizingMaskIntoConstraints = false
        segmentedControl.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(headerView)
        view.addSubview(segmentedControl)
        view.addSubview(collectionView)
        
        scanButton.addTarget(
            self,
            action: #selector(scanButtonTapped),
            for: .touchUpInside
        )
        
        setUpHeaderView()
        setUpSegmentedControl()
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
            
            // Segmented control
            segmentedControl.topAnchor.constraint(
                equalTo: headerView.bottomAnchor,
                constant: 24
            ),
            segmentedControl.leadingAnchor.constraint(
                equalTo: view.leadingAnchor,
                constant: 20
            ),
            segmentedControl.trailingAnchor.constraint(
                equalTo: view.trailingAnchor,
                constant: -20
            ),
            segmentedControl.heightAnchor.constraint(
                equalToConstant: 36
            ),
            
            // Collection view: fills the space under the segmented control
            collectionView.topAnchor.constraint(
                equalTo: segmentedControl.bottomAnchor,
                constant: 16
            ),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
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
    
    private func setUpSegmentedControl() {
        segmentedControl.selectedSegmentIndex = 0
        
        segmentedControl.addTarget(
            self,
            action: #selector(layoutChanged),
            for: .valueChanged
        )
    }
    
    @objc private func layoutChanged() {
        collectionView.collectionViewLayout.invalidateLayout()
        
          // Refresh the displayed cells
    collectionView.reloadData()
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            print("Grid selected")
        case 1:
            print("List selected")
        default:
            break
        }
    }
    
    @objc private func scanButtonTapped(){
        switch AVCaptureDevice.authorizationStatus(for: .video) {
            
        case .authorized:
            let alert = UIAlertController(
                title: "Camera Access",
                message: "Camera access is enabled. Would you like to start scanning?",
                preferredStyle: .alert
            )
            
            alert.addAction(
                UIAlertAction(title: "Cancel", style: .cancel)
            )
            
            alert.addAction(
                UIAlertAction(title: "Continue", style: .default) { [weak self] _ in
                    self?.openScanner()
                }
            )
            
            present(alert, animated: true)
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                Task { @MainActor in
                    guard let self else { return }
                    
                    if granted {
                        self.openScanner()
                    } else {
                        self.showCameraPermissionAlert()
                    }
                }
            }
        case .denied:
            if let settingsURL = URL(
                string: UIApplication.openSettingsURLString
            ) {
                UIApplication.shared.open(settingsURL)
            }                
            
        case .restricted:
            showCameraPermissionAlert()
            
        @unknown default:
            showCameraPermissionAlert()
        }
    }
    
    private func showCameraPermissionAlert() {
        let alert = UIAlertController(
            title: "Camera Access Needed",
            message: "Please allow camera access in Settings to scan QR codes.",
            preferredStyle: .alert
        )
        alert.addAction(
            UIAlertAction(title: "Cancel", style: .cancel)
        )
        
        alert.addAction(
            UIAlertAction(title: "Open Settings", style: .default) { _ in
                guard let settingsURL = URL(
                    string: UIApplication.openSettingsURLString
                ) else {
                    return
                }

                UIApplication.shared.open(settingsURL)
            }
        )

        present(alert, animated: true)
    }
    
    private func openScanner() {
        let scannerVC = ScannerViewController()
        
        scannerVC.delegate = self
        scannerVC.modalPresentationStyle = .fullScreen
        
        present(scannerVC, animated: true)
    }
    
    @MainActor
    private func saveQRCode(_ code: String) {
        let newItem = QRCodeItem(
            text: code,
            date: .now
        )
        
        items.insert(newItem, at: 0)
        
        collectionView.reloadData()
    }
}

extension QRCodesViewController: UICollectionViewDataSource {
    
    //how many boxes
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        items.count // one box per item
    }
    
    
    //"Give me the box for row number X"
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        // Ask for a recycled box (or a new one), and make sure it's our QRCodeCell type
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: QRCodeCell.reuseIdentifier,
            for: indexPath
        ) as? QRCodeCell else {
            return UICollectionViewCell()
        }

        
        // Put this row's text and date into the box
        cell.configure(with: items[indexPath.item])
        return cell
    }
}


extension QRCodesViewController {
  
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let detail = QRCodeDetailViewController(item: items[indexPath.item])
        present(detail, animated: true)
    }
}


//MARK: Grid or List
extension QRCodesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {

        let spacing: CGFloat = 10

        if segmentedControl.selectedSegmentIndex == 0 {
            // Grid: two square cards per row
            let width = (collectionView.bounds.width - spacing) / 2
            return CGSize(width: width, height: width)
        } else {
            // List: full-width horizontal rows (your original layout)
            return CGSize(
                width: collectionView.bounds.width,
                height: 80
            )
        }
    }
}




#Preview {
    UINavigationController(rootViewController: QRCodesViewController())
}

extension QRCodesViewController: ScannerViewControllerDelegate {
    
    func scannerViewController(
        _ controller: ScannerViewController,
        didScan code: String
    ) {
        saveQRCode(code)
    }
}
