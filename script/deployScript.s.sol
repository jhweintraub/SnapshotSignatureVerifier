// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Script.sol";
import "src/SignatureVerifier.sol";

contract ContractScript is Script {
    function setUp() public {}

    function run() public {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        vm.startBroadcast(deployerPrivateKey);

        SignatureVerifier verifier = new SignatureVerifier();

        console.log("Contract Deployed to: ", address(verifier));

        vm.stopBroadcast();
    }
}
