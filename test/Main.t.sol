// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import "forge-std/Test.sol";
import "../src/Main.sol";

contract CounterTest is Test {
    Main main;
    address player1 = makeAddr("player1");
    address player2 = makeAddr("player2");
    address player3 = makeAddr("player3");

    struct Player {
        uint id;
        string name;
        uint256 level;
        uint256 exp;
        bool alive;
        Attributes attributes;
    }

    struct Attributes {
        uint256 strength;
        uint256 agility;
        uint256 intelligence;
    }

    function setUp() public {
        main = new Main();
    }

    function testCreatePlayer() public {
        vm.startPrank(player1);
        main.createPlayer("player1");

        (
            uint id,
            string memory name,
            uint256 level,
            uint256 exp,
            uint256 gold,
            uint timeToWait,
            ,
            ,

        ) = main.players(player1);
        assertEq(main.quantity_players(), 1);
        assertEq(id, 1);
        assertEq(name, "player1");
        assertEq(level, 1);
        assertEq(exp, 0);
        // assertEq(alive, true);
    }

    function testCreatePlayerTwice() public {
        vm.startPrank(player1);
        main.createPlayer("player1");

        vm.startPrank(player1);
        vm.expectRevert();
        main.createPlayer("player1");
    }

    function testAttackOneMonster() public {
        vm.startPrank(player1);
        skip(1000 seconds);
        main.createPlayer("player1");

        skip(4000 seconds);
        main.determineWinnerWithCreature(1); // 1 == Goblin,  the weakest creature
    }

    // function testHello(uint16 _n) public {
    //     vm.startPrank(player1);
    //     main.createPlayer("player1");
    //     skip(_n);
    //     main.determineWinnerWithCreature(1); // 1 == Goblin,  the weakest creature
    // }

    modifier createPlayer() {
        vm.startPrank(player1);
        main.createPlayer("player1");
        _;
    }

    function _getStatus() private {
        // (uint256 id, , , , , , , main.Player, , , ) = main.get_players(player1);
        Main.Player memory player = main.get_players(player1);
        uint256 wins = player.battleStats.wins;
        uint256 losses = player.battleStats.losses;
        uint256 draws = player.battleStats.draws;
        uint256 gold = player.gold;

        console.log("wins:", wins);
        console.log("losses:", losses);
        console.log("draws:", draws);
        console.log("GOLD:", gold);
        console.log("-------------");

        console.log("strength:", player.attributes.strength);
        console.log("agility:", player.attributes.agility);
        console.log("intelligence:", player.attributes.intelligence);
        console.log("====================================");
    }

    function testAttackOneMonsterWithPlayer() public createPlayer {
        _getStatus();
        main.determineWinnerWithCreature(1); // 1 == Goblin,  the weakest creature
        _getStatus();
        skip(10 minutes);
        main.determineWinnerWithCreature(1); // 1 == Goblin,  the weakest creature
        _getStatus();
        skip(10 minutes);
        main.determineWinnerWithCreature(1); // 1 == Goblin,  the weakest creature
        _getStatus();
        skip(10 minutes);
        main.determineWinnerWithCreature(1); // 1 == Goblin,  the weakest creature
        _getStatus();
        skip(10 minutes);
        main.determineWinnerWithCreature(1); // 1 == Goblin,  the weakest creature
        _getStatus();
        skip(10 minutes);
        main.determineWinnerWithCreature(1); // 1 == Goblin,  the weakest creature
        _getStatus();
        skip(10 minutes);
        main.determineWinnerWithCreature(1); // 1 == Goblin,  the weakest creature
        _getStatus();
        skip(10 minutes);
        main.determineWinnerWithCreature(1); // 1 == Goblin,  the weakest creature
        _getStatus();
        skip(10 minutes);
        main.determineWinnerWithCreature(1); // 1 == Goblin,  the weakest creature
        _getStatus();

        main.improveAttribute(1);
        _getStatus();
        main.improveAttribute(1);
        _getStatus();
        main.improveAttribute(2);
        _getStatus();
        main.improveAttribute(3);
        _getStatus();
        main.improveAttribute(3);
        _getStatus();

        // attack a stronger monster
        skip(11 minutes);
        main.determineWinnerWithCreature(3); // 3 == Dragon
        _getStatus();
    }

    function testAttackAnotherPlayer() public {
        vm.startPrank(player1);
        main.createPlayer("player1");

        vm.startPrank(player2);
        main.createPlayer("player2");

        vm.startPrank(player1);
        main.attackPlayer("player2");

        // print status
        _getStatus2("player1");
        _getStatus2("player2");
    }

    function testAttackMonsterImproveThenAnotherPlayer() public {
        vm.startPrank(player1);
        main.createPlayer("player1");

        main.determineWinnerWithCreature(1); // 1 == Goblin,  the weakest creature

        skip(10 minutes); // do i need to skip time if i want to attack a player after attacking a monster?
        // improve attribute
        main.improveAttribute(1);

        console.log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
        _getStatus2("player1");
        console.log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");

        vm.startPrank(player2);
        main.createPlayer("player2");

        vm.startPrank(player1);
        main.attackPlayer("player2");

        skip(24 hours);
        main.attackPlayer("player2");

        // print status
        _getStatus2("player1");
        _getStatus2("player2");
    }

    function testAttackMonsterImproveThenAnotherPlayer2() public {
        vm.startPrank(player1);
        main.createPlayer("player1");

        main.determineWinnerWithCreature(1); // 1 == Goblin,  the weakest creature

        skip(10 minutes); // do i need to skip time if i want to attack a player after attacking a monster?
        // improve attribute
        main.improveAttribute(1);

        console.log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");
        _getStatus2("player1");
        console.log("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@");

        vm.startPrank(player2);
        main.createPlayer("player2");

        main.determineWinnerWithCreature(1);

        main.improveAttribute(2); // improve agility
        console.log("#######################");
        _getStatus2("player2");
        console.log("#######################");
        //

        // vm.startPrank(player1);
        // main.attackPlayer("player2");

        vm.startPrank(player1);
        skip(24 hours);
        main.attackPlayer("player2");

        // print status
        console.log("P1:");
        _getStatus2("player1");
        console.log("P2:");
        _getStatus2("player2");
    }

    function _getStatus2(string memory __player) private view {
        Main.Player memory player = main.get_players(
            main.name_to_address(__player)
        );

        uint256 exp = player.exp;
        uint256 wins = player.battleStats.wins;
        uint256 losses = player.battleStats.losses;
        uint256 draws = player.battleStats.draws;
        uint256 gold = player.gold;

        console.log("exp:", exp);
        console.log("wins:", wins);
        console.log("losses:", losses);
        console.log("draws:", draws);
        console.log("GOLD:", gold);
        console.log("-------------");
    }

    //
    function testTuningLuckParam() public createPlayer {
        main.determineWinnerWithCreature(1); // 1 == Goblin,  the weakest creature
        skip(14 minutes);
        // main.determineWinnerWithCreature(1); // 1 == Goblin,  the weakest creature
        // skip(14 minutes);
        // main.determineWinnerWithCreature(1); // 1 == Goblin,  the weakest creature
        // skip(15 minutes);
        // main.determineWinnerWithCreature(1); // 1 == Goblin,  the weakest creature
    }

    function testAttackStrongMonster() public createPlayer {
        string memory result = main.determineWinnerWithCreature(1); // 1 == Globin the weakest creature
        console.log("winner:", result);

        skip(10 minutes);

        string memory result2 = main.determineWinnerWithCreature(3); // 3 == Dragon,  the strongest creature
        console.log("winner:", result2);
    }
}
