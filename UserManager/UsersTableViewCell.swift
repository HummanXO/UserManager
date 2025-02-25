import UIKit

class UsersTableViewCell: UITableViewCell {
    
    let imageViewUser: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 30
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    let firstNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18, weight: .bold)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let lastNameLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 18)
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    let emailLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = .lightGray
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let nameStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 8
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let mainStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .black
        selectionStyle = .none
        
        nameStackView.addArrangedSubview(firstNameLabel)
        nameStackView.addArrangedSubview(lastNameLabel)

        mainStackView.addArrangedSubview(nameStackView)
        mainStackView.addArrangedSubview(emailLabel)

        contentView.addSubview(imageViewUser)
        contentView.addSubview(mainStackView)
        
        setupConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            imageViewUser.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            imageViewUser.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            imageViewUser.widthAnchor.constraint(equalToConstant: 60),
            imageViewUser.heightAnchor.constraint(equalToConstant: 60),
            
            mainStackView.leadingAnchor.constraint(equalTo: imageViewUser.trailingAnchor, constant: 16),
            mainStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            mainStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            mainStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16)
        ])
    }
    
    func configure(with user: User) {
        firstNameLabel.text = user.first_name
        lastNameLabel.text = user.last_name
        emailLabel.text = user.email
        
        imageViewUser.image = nil  // Сбрасываем, чтобы не оставалось старых картинок
        
        if let url = user.avatarURL {
            loadImage(from: url)
        }
    }
    
    private func loadImage(from url: URL) {
        URLSession.shared.dataTask(with: url) { [weak self] data, _, error in
            guard let self = self, let data = data, error == nil, let image = UIImage(data: data) else { return }
            DispatchQueue.main.async {
                self.imageViewUser.image = image
            }
        }.resume()
    }
}
