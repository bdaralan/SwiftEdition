import XCTest
@testable import ClosureEdition


final class ClosureTests: XCTestCase {
    
    class Pokemon {
        
        var name: String
        var level: Int
        var item: String?
        
        init(name: String, level: Int) {
            self.name = name
            self.level = level
        }
    }
    
    class PokemonTrainer {
        
        var pokemons: [Pokemon] = []
        
        func levelUp(pokemon: Pokemon) {
            pokemon.level += 1
        }
        
        func give(item: String?, to pokemon: Pokemon) {
            pokemon.item = item
        }
    }
    
    var pikachu: Pokemon!
    var torchic: Pokemon!
    var trainer: PokemonTrainer!

    override func setUp() {
        super.setUp()
        pikachu = .init(name: "Pikachu", level: 1)
        torchic = .init(name: "Torchic", level: 1)
    
        trainer = .init()
        trainer.pokemons = [pikachu, torchic]
    }
    
    func testGuardWithoutArgument() {
        let giveEverStone = weak(trainer) { trainer in
            for pokemon in trainer.pokemons {
                trainer.give(item: "EverStone", to: pokemon)
            }
        }

        XCTAssertNil(pikachu.item)
        XCTAssertNil(torchic.item)

        giveEverStone()

        XCTAssertEqual(pikachu.item, "EverStone")
        XCTAssertEqual(torchic.item, "EverStone")

        trainer.give(item: nil, to: pikachu)
        trainer.give(item: nil, to: torchic)
        trainer = nil

        giveEverStone()

        XCTAssertNil(pikachu.item)
        XCTAssertNil(torchic.item)
    }
    
    func testGuardWithArgument() {
        let levelUp = weak(trainer) { trainer, pokemon in
            trainer.levelUp(pokemon: pokemon)
        }
        
        XCTAssertEqual(pikachu.level, 1)
        
        levelUp(pikachu)
        
        XCTAssertEqual(pikachu.level, 2)
        
        trainer = nil
        
        levelUp(pikachu)
        
        XCTAssertEqual(pikachu.level, 2)
    }
    
    func testGuardWithTupleArgument() {
        let giveItem: (String?, Pokemon) -> Void = weak(trainer) { trainer, item, pokemon in
            trainer.give(item: item, to: pokemon)
        }
        
        XCTAssertNil(pikachu.item)
        
        giveItem("ThunderStone", pikachu)
        
        XCTAssertEqual(pikachu.item, "ThunderStone")
        
        trainer = nil
        
        giveItem(nil, pikachu)
        
        XCTAssertEqual(pikachu.item, "ThunderStone")
    }
}
