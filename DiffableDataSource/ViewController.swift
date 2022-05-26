//
//  ViewController.swift
//  DiffableDatasource
//
//  Created by Rosendo Vazquez Bailon on 25/05/22.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate {
    
    let tableView:UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    enum Section {
        case first
        case second
    }
    
    struct Pokemon:Hashable {
        let name:String
    }
    
    var datasource:UITableViewDiffableDataSource<Section, Pokemon>!
    
    var pokemons = [Pokemon]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        view.addSubview(tableView)
        tableView.frame = view.bounds
        
        datasource = UITableViewDiffableDataSource(tableView: tableView, cellProvider: { tableView, indexPath, model -> UITableViewCell? in
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
            
            let imgAvatar:UIImageView = {
                let img = UIImageView()
                img.image = UIImage(systemName: "lock")
                img.contentMode = .scaleAspectFill
                img.clipsToBounds = true
                return img
            }()
            
            let name:UILabel = {
                let label = UILabel()
                label.text = model.name
                return label
            }()
            
            cell.addSubview(imgAvatar)
            imgAvatar.frame = CGRect(x: 20, y: ((cell.frame.height / 2) - 40), width: 80, height: 80)
            
            cell.addSubview(name)
            name.frame = CGRect(x: 120, y: ((cell.frame.height / 2) - 10), width: 140, height: 20)
            
            return cell
        })
        
        
        title = "Pokemon"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "star"), style: .done, target: self, action: #selector(didTapAdd))
    }
    
    @objc func didTapAdd(){
        let actionSheet = UIAlertController(title: "Pick one pokemon", message: nil, preferredStyle: .actionSheet)
        
        for element in 0...100{
            actionSheet.addAction(UIAlertAction(title: "Pokemon \(element+1)", style: .default, handler: { [weak self] _ in
                let pokemon = Pokemon(name: "Pokemon \(element+1)")
                self?.pokemons.append(pokemon)
                self?.updateDatasource()
            }))
        }
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(actionSheet, animated: true)
    }
    
    
    func updateDatasource(){
        var snapshot = NSDiffableDataSourceSnapshot<Section, Pokemon>()
        snapshot.appendSections([.first])
        snapshot.appendItems(pokemons)
        
        datasource.apply(snapshot, animatingDifferences: true, completion: nil)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        guard let pokemonPicked = datasource.itemIdentifier(for: indexPath) else { return }
        print(pokemonPicked.name)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 148
    }
    
}

