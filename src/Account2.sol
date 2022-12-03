// SPDX-License-Identifier: AGPL-3.0-only
pragma solidity ^0.8.15;

import "solmate/auth/Owned.sol";
import "solmate/auth/Auth.sol";

contract Account2 is Owned {
    constructor() Owned(msg.sender) {}

    function executeAsRelay(
        address toCall,
        bytes calldata params,
        uint256 gasLimit,
        uint256 gasTokenRatio,  // preferably >x, x = gas price in token
        address gasToken) external {
            // (bool success, bytes memory data) = toCall.call(bytes.concat(select, params));
            uint256 gasUsed = gasleft();
            (bool success, bytes memory data) = toCall.call(params);

            gasUsed -= gasleft() + 21000;
            require(gasUsed <= gasLimit, 'gas limit exceeded');

            uint256 amountToTransfer = (gasUsed * gasTokenRatio);
    }

    function executeAsOwner(
        address toCall,
        bytes calldata params
    ) external onlyOwner {
        (bool success, bytes memory data) = toCall.call(params);
    }
}