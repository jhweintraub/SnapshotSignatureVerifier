// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import "forge-std/Test.sol";
import "../src/SignatureVerifier.sol";
import "openzeppelin/utils/cryptography/ECDSA.sol";
import "forge-std/console.sol";

contract VerifierTest is Test {
    SignatureVerifier public verifier;

    enum RecoverError {
        NoError,
        InvalidSignature,
        InvalidSignatureLength,
        InvalidSignatureS,
        InvalidSignatureV // Deprecated in v4.8
    }

    function setUp() public {
        verifier = new SignatureVerifier();
        
    }

   function testSignatureVerification() public {
        address expectedSigner = 0x070341aA5Ed571f0FB2c4a5641409B1A46b4961b;
 
        SignatureVerifier.SingleChoiceVote memory vote = SignatureVerifier.SingleChoiceVote({
        from: expectedSigner,
        space: "aave.eth",
        timestamp: 1677271449,
        proposal: 0x15a031fa5f848aac269214a7cda2fed314590ab0c935b6879e4bf7fb9d87cc2c,
        choice: 1,
        reason: "",
        app: "snapshot",
        metadata: "{}"
        });

        bytes memory signature = hex"ba87e5918ea6c7e0e3301d149ac9263e30e3e46aee545e1cc49240edf8f402777d6642d1f3db11a34539073199bf8767af24223e1c28dd4f50b4cbf4daa30df21c";
        
        bytes32 digest = keccak256(abi.encodePacked(
            "\x19\x01",
            verifier.DOMAIN_SEPARATOR(),
            verifier.hash(vote)
        ));
        (address signer, ECDSA.RecoverError errorCode) = ECDSA.tryRecover(digest, signature);
        assertEq(uint(errorCode), 0, "ECDSA Error occured when recovering signer");
        assertEq(signer, expectedSigner, "actual signer could not be verified as expected");
    }

    function testSignaturesWithMultipleChoices() public {
        address expectedSigner = 0x48A9789428F2067338D02B1EF3612DF64F05FeB7;
        uint32[] memory choices = new uint32[](2);
        choices[0] = 1;
        choices[1] = 3;
 
        SignatureVerifier.MultiChoiceVote memory vote = SignatureVerifier.MultiChoiceVote({
            from: expectedSigner,
            space: "uniswap",
            timestamp: 1677339283,
            proposal: 0xbadf3b39b681c98ba8fb988d5b6c9454ebeb5aae88545a6a852d0734e9f7c957,
            choice: choices,
            reason: "",
            app: "snapshot",
            metadata: "{}"
        });

        bytes memory signature = hex"bd9d68b3beb9b063f3df6338be93ea3c21a3752ab9d90a0b53eb0f13dd066f8f42ae7ea8e7d11cf9ae8d8562f88b31ad76f0bb2399dd80b35b79f22dabd0f7131b";
        
        bytes32 digest = keccak256(abi.encodePacked(
            "\x19\x01",
            verifier.DOMAIN_SEPARATOR(),
            verifier.hash(vote)
        ));

        (address signer, ECDSA.RecoverError errorCode) = ECDSA.tryRecover(digest, signature);
        assertEq(uint(errorCode), 0, "ECDSA Error occured when recovering signer");
        assertEq(signer, expectedSigner, "actual signer could not be verified as expected");

    }
}
