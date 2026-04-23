//
//  ExploreViewController.swift
//  hello_world
//
//  Created by Hannah Valencia on 22/04/26.
//

import UIKit
import Combine

class ExploreViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var btnAdd: UIButton!
    @IBOutlet weak var lblTitle: UILabel!

    // MARK: - Propiedades privadas
    private let viewModel    = ExploreViewModel()
    private var cancellables = Set<AnyCancellable>()

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTableView()
        setupBindings()
        setupUI()

        btnAdd.addTarget(self, action: #selector(addTapped), for: .touchUpInside)
    }

    // MARK: - Setup
    private func setupUI() {
        lblTitle.text          = "UBICACIONES\nGUARDADAS"
        lblTitle.numberOfLines = 2
        lblTitle.font          = UIFont.systemFont(ofSize: 22, weight: .black)

        let cfg = UIImage.SymbolConfiguration(pointSize: 28, weight: .regular)
        btnAdd.setImage(UIImage(systemName: "plus.circle", withConfiguration: cfg), for: .normal)
        btnAdd.tintColor = .systemOrange
        btnAdd.setTitle("", for: .normal)

        tableView.separatorStyle  = .none
        tableView.backgroundColor = UIColor(red: 0.878, green: 0.937, blue: 0.976, alpha: 1.0)
        tableView.contentInset    = UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)
    }

    private func setupTableView() {
        tableView.dataSource = self
        tableView.register(ExploreCell.self, forCellReuseIdentifier: ExploreCell.reuseID)
    }

    private func setupBindings() {
        viewModel.$locations
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.tableView.reloadData()
            }
            .store(in: &cancellables)
    }

    // MARK: - Actions
    @objc private func addTapped() {
        let alert = UIAlertController(
            title: "Agregar ubicación",
            message: nil,
            preferredStyle: .alert
        )
        alert.addTextField { tf in
            tf.placeholder            = "Nombre de la ciudad"
            tf.autocapitalizationType = .words
            tf.autocorrectionType     = .no
        }
        let addAction = UIAlertAction(title: "Agregar", style: .default) { [weak self] _ in
            guard let self,
                  let city = alert.textFields?.first?.text?.trimmingCharacters(in: .whitespaces),
                  !city.isEmpty
            else { return }
            self.viewModel.addLocation(city: city)
        }
        alert.addAction(addAction)
        alert.addAction(UIAlertAction(title: "Cancelar", style: .cancel))
        present(alert, animated: true)
    }
}

// MARK: - UITableViewDataSource
extension ExploreViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.locations.count
    }

    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: ExploreCell.reuseID,
            for: indexPath
        ) as? ExploreCell else { return UITableViewCell() }

        cell.configure(with: viewModel.locations[indexPath.row])
        return cell
    }
}
