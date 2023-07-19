// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC721/IERC721.sol";
import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "../lib/knowyourcat-sdk/src/interfaces/IAggregator.sol";
import "../lib/knowyourcat-sdk/src/constants/SourceId.sol";

contract KnowYourDAO {
    IAggregator aggregator;
    IERC721 category;
    IERC20 public token;

    struct Proposal {
        string description;
        uint256 voteCount;
        mapping(address => bool) votes;
    }

    Proposal[] public proposals;

    constructor(
        IAggregator aggregator_,
        IERC721 category_,
        IERC20 token_
    ) {
        aggregator = aggregator_;
        category = category_;
        token = token_;
    }

    function hasSourceIdSynced(address account_) external view returns (bool) {
        return aggregator.isSynced(SourceId.BAB, account_).payload > 0;
    }

    function hasCategory(address account_) external view returns (bool) {
        return category.balanceOf(account_) > 0;
    }

    function createProposal(string memory _description) external {
        require(this.hasCategory(msg.sender), "Only members with category can create proposals");
        
        // Create the proposal directly in the proposals array:
        Proposal storage newProposal = proposals.push();
        newProposal.description = _description;
    }

    function vote(uint256 _proposalId) external {
        require(this.hasCategory(msg.sender), "Only members with category can note");
        
        Proposal storage proposal = proposals[_proposalId];
        require(!proposal.votes[msg.sender], "User has already voted on this proposal");

        proposal.votes[msg.sender] = true;
        proposal.voteCount += token.balanceOf(msg.sender);
    }
}
