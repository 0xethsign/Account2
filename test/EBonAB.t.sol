// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import "forge-std/Test.sol";

import {Greeter} from "src/Greeter.sol";
import {EBonAB} from "src/EBonAB.sol";

contract EBonAbTest is Test {
    using stdStorage for StdStorage;

    Greeter greeter;
    EBonAB ea;

    function setUp() external {
        ea = new EBonAB();
        greeter = new Greeter("gm");
    }



    //VM Cheatcodes can be found in ./lib/forge-std/src/Vm.sol
    //Or at https://github.com/foundry-rs/forge-std
    function testSetGm() external {
        bytes memory greet = abi.encode("gm");
        bytes4 select = bytes4(keccak256(abi.encodePacked("gm(string)")));

        ea.executeAsOwner(address(greeter), bytes.concat(select, greet));

        // //slither-disable-next-line reentrancy-events,reentrancy-benign
        // greeter.setGreeting("gm gm");

        // // Expect the GMEverybodyGM event to be fired
        // vm.expectEmit(true, true, true, true);
        // emit GMEverybodyGM();
        // // slither-disable-next-line unused-return
        // greeter.gm("gm gm");

        // // Expect the gm() call to revert
        // vm.expectRevert(abi.encodeWithSignature("BadGm()"));
        // // slither-disable-next-line unused-return
        // greeter.gm("gm");

        // // We can read slots directly
        // uint256 slot = stdstore.target(address(greeter)).sig(greeter.owner.selector).find();
        // assertEq(slot, 1);
        // bytes32 owner = vm.load(address(greeter), bytes32(slot));
        // assertEq(address(this), address(uint160(uint256(owner))));
    }

}
