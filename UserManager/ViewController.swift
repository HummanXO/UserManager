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
        view.backgroundColor = .black
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
        let alertController = UIAlertController(title: "Add User", message: nil, preferredStyle: .alert)
        alertController.addTextField { textField in
            textField.placeholder = "Enter user name"
        }
        alertController.addTextField { textField in
            textField.placeholder = "Enter user email"
        }
        let actionAdd = UIAlertAction(title: "Add", style: .default) { [weak self] _ in
            guard let self = self,
                  let firstName = alertController.textFields?.first?.text,
                  let email = alertController.textFields?.last?.text else { return }
            self.createUser(firstName: firstName, email: email)
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(actionAdd)
        alertController.addAction(actionCancel)
        present(alertController, animated: true)
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
    
    private func createUser(firstName: String, email: String) {
        networkManager.createUser(first_name: firstName, email: email) { [weak self] result in
            guard let self = self, let res = result else { return }
            
            self.users.append(res)
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let userToDelete = users[indexPath.row]
            networkManager.deleteUser(user: userToDelete) { [weak self] _ in
                guard let self = self else { return }
                self.users.remove(at: indexPath.row)
                DispatchQueue.main.async {
                    tableView.deleteRows(at: [indexPath], with: .fade)
                }
            }
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "UserCell", for: indexPath) as! UsersTableViewCell
        let user = users[indexPath.row]
        cell.configure(with: user)
        return cell
    }

}
