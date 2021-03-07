import XCTest
@testable import UtilityEdition


final class ActionTests: XCTestCase {
    
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
        let giveEverStone = Action.weak(trainer) { trainer in
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
        let levelUp = Action.weak(trainer) { trainer, pokemon in
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
        let argumentType = (item: String?, pokemon: Pokemon).self
        
        let giveItem = Action.weak(trainer, argument: argumentType) { trainer, argument in
            trainer.give(item: argument.item, to: argument.pokemon)
        }
        
        XCTAssertNil(pikachu.item)
        
        giveItem(("ThunderStone", pikachu))
        
        XCTAssertEqual(pikachu.item, "ThunderStone")
        
        trainer = nil
        
        giveItem((nil, pikachu))
        
        XCTAssertEqual(pikachu.item, "ThunderStone")
    }
}
