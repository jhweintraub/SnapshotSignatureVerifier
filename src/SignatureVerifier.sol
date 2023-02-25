// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

contract SignatureVerifier {

    struct EIP712Domain {
        string  name;
        string  version;
    }

    struct SingleChoiceVote {
        address from;
        string space;
        uint64 timestamp;
        bytes32 proposal;
        uint32 choice;
        string reason;
        string app;
        string metadata;
    }

    struct MultiChoiceVote {
        address from;
        string space;
        uint64 timestamp;
        bytes32 proposal;
        uint32[] choice;
        string reason;
        string app;
        string metadata;
    }

    bytes32 constant EIP712DOMAIN_TYPEHASH = keccak256(
        "EIP712Domain(string name,string version)"
    );

    //TODO: Consider changing proposal to a bytes32
    bytes32 constant SINGLE_CHOICE_VOTE_TYPEHASH = keccak256(
        "Vote(address from,string space,uint64 timestamp,bytes32 proposal,uint32 choice,string reason,string app,string metadata)"
    );

    bytes32 constant MULTI_CHOICE_VOTE_TYPEHASH = keccak256(
        "Vote(address from,string space,uint64 timestamp,bytes32 proposal,uint32[] choice,string reason,string app,string metadata)"
    );

    bytes32 public DOMAIN_SEPARATOR;

    constructor() {
        DOMAIN_SEPARATOR = hash(EIP712Domain({
            name: "snapshot",
            version: "0.1.4"
        }));
    }

    function hash(EIP712Domain memory eip712Domain) public pure returns (bytes32) {
        return keccak256(abi.encode(
            EIP712DOMAIN_TYPEHASH,
            keccak256(bytes(eip712Domain.name)),
            keccak256(bytes(eip712Domain.version))
        ));
    }

    function hash(SingleChoiceVote calldata vote) public pure returns (bytes32) {
        return keccak256(abi.encode(
            SINGLE_CHOICE_VOTE_TYPEHASH,
            vote.from,
            keccak256(bytes(vote.space)),
            vote.timestamp,
            vote.proposal,
            vote.choice,
            keccak256(bytes(vote.reason)),
            keccak256(bytes(vote.app)),
            keccak256(bytes(vote.metadata))
        ));
    }

    function hash(MultiChoiceVote calldata vote) public pure returns (bytes32) {
        return keccak256(abi.encode(
            MULTI_CHOICE_VOTE_TYPEHASH,
            vote.from,
            keccak256(bytes(vote.space)),
            vote.timestamp,
            vote.proposal,
            keccak256(abi.encodePacked(vote.choice)),
            keccak256(bytes(vote.reason)),
            keccak256(bytes(vote.app)),
            keccak256(bytes(vote.metadata))
        ));
    }

}