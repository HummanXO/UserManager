import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var users: [User] = []
    
    
    private let networkManager = NetworkManager()
    
    private let tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 100
        tableView.backgroundColor = .black
        tableView.register(UsersTableViewCell.self, forCellReuseIdentifier: "UserCell")
        return tableView
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        fetchUsers()
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.titleTextAttributes = [.foregroundColor: UIColor.white]
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addUser))
        navigationItem.title = "Users Manager"
    }
    
    @objc private func addUser() {
        
    }
    
    private func setupTableView() {
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
            ])
    }
    
    private func fetchUsers() {
        networkManager.fetchData { [weak self] result in
            guard let self = self, let res = result?.data else { return }
            self.users = res
            DispatchQueue.main.async {
                self.tableView.reloadData()
                print(self.users)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UsersTableViewCell
        let user = users[indexPath.row]
        cell.configure(with: user)
        return cell
    }

}

