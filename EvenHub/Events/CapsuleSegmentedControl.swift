import UIKit

class CapsuleSegmentedControl: UIControl {
    
    private var buttons: [UIButton] = []
    private let stackView = UIStackView()
    private let selectorView = UIView()
    
    private(set) var selectedIndex: Int = 0
    var items: [String] {
        didSet { configureButtons() }
    }
    
    init(items: [String]) {
        self.items = items
        super.init(frame: .zero)
        setupView()
        configureButtons()
        setupSelector()
        selectSegment(at: 0, animated: false)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not supported")
    }
    
    private func setupView() {
        backgroundColor = UIColor(white: 0.97, alpha: 1) // светло-серый фон
        layer.cornerRadius = 22
        clipsToBounds = true
        
        stackView.axis = .horizontal
        stackView.distribution = .fillEqually
        addSubview(stackView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            stackView.topAnchor.constraint(equalTo: topAnchor),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func configureButtons() {
        buttons.forEach { $0.removeFromSuperview() }
        buttons = items.map { title in
            let button = UIButton(type: .custom)
            button.setTitle(title, for: .normal)
            button.setTitleColor(.color30, for: .normal)
            button.setTitleColor(.blue50, for: .selected)
            button.titleLabel?.font = UIFont(name: Constants.Fonts.book, size: 15)
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
            return button
        }
        buttons.forEach { stackView.addArrangedSubview($0) }
    }
    
    private func setupSelector() {
        selectorView.backgroundColor = .white
        selectorView.layer.cornerRadius = 18
        selectorView.layer.shadowColor = UIColor.black.cgColor
        selectorView.layer.shadowOpacity = 0.1
        selectorView.layer.shadowOffset = CGSize(width: 0, height: 2)
        selectorView.layer.shadowRadius = 4
        insertSubview(selectorView, at: 0) // под кнопками
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateSelector(animated: false)
    }
    
    @objc private func buttonTapped(_ sender: UIButton) {
        guard let index = buttons.firstIndex(of: sender) else { return }
        selectSegment(at: index, animated: true)
        sendActions(for: .valueChanged)
    }
    
    func selectSegment(at index: Int, animated: Bool) {
        buttons.enumerated().forEach { i, btn in
            btn.isSelected = (i == index)
        }
        selectedIndex = index
        updateSelector(animated: animated)
    }
    
    private func updateSelector(animated: Bool) {
        guard !buttons.isEmpty else { return }
        let selectedButton = buttons[selectedIndex]
        let targetFrame = selectedButton.frame.insetBy(dx: 6, dy: 6)
        
        if animated {
            UIView.animate(
                withDuration: 0.3,
                delay: 0,
                usingSpringWithDamping: 0.7,
                initialSpringVelocity: 0.7,
                options: [.curveEaseInOut],
                animations: {
                    self.selectorView.frame = targetFrame
                }
            )
        } else {
            selectorView.frame = targetFrame
        }
    }
}
