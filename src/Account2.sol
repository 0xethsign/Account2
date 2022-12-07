// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import "solmate/auth/Owned.sol";
import "solmate/auth/Auth.sol";

interface IERC20 {
    function balanceOf(address account) external view returns (uint256);
    function transfer(address to, uint256 amount) external returns (bool);
}
contract Account2 is Owned {
    uint256 nonce = 0;
    constructor() Owned(msg.sender) {}

    function executeAsRelay(
        address toCall,
        bytes calldata params,
        uint256 _nonce,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (bool) {
        // validate nonce
        require(nonce == _nonce, 'nonce too low');
        // recover hash signature
        bytes32 hash = keccak256(abi.encodePacked(toCall, params, nonce));
        // increment nonce
        nonce++;
        // recover signer
        address signer = ecrecover(hash, v, r, s);
        // validate signer
        require(signer == owner && signer != address(0), "invalid signature");
        // forward txn params
        (bool success, ) = toCall.call(params);
        return success;
    }

    function executeWithEconomicAbstraction(
        address toCall,
        bytes calldata params,
        uint256 gasTokenRatio,  // preferably >x, x = gas price in token
        address gasToken
    ) public returns (bool) {
        require(msg.sender == address(this));
        uint256 gasUsed = gasleft();
        (bool success, ) = toCall.call(params);
        gasUsed -= gasleft() + 21000;

        uint256 amount = (gasUsed * gasTokenRatio);
        uint256 balance = IERC20(gasToken).balanceOf(address(this));
        amount = amount > balance ? balance : amount;
        require(IERC20(gasToken).transfer(tx.origin, amount), 'gasToken balance too low');
        return success;
    }

    function executeAsOwner(
        address toCall,
        bytes calldata params
    ) external onlyOwner returns (bool) {

        (bool success, ) = toCall.call(params);

        return success;
    }
}