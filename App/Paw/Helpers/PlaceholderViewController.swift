//
// PlaceholderViewController.swift
//

import UIKit

final class PlaceholderViewController: UIViewController {
    private let text: String

    init(text: String) {
        self.text = text
        super.init(nibName: .none, bundle: .none)
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        let label = UILabel(frame: view.frame)
        label.text = text
        label.font = .boldSystemFont(ofSize: 22)
        label.textColor = .label
        label.textAlignment = .center

        view.addSubview(label)
    }
}
