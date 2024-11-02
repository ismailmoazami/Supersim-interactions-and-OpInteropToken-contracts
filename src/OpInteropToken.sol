// SPDX-License-Identifier: MIT
pragma solidity 0.8.25; 

import {SuperchainERC20} from "@contracts-bedrock/L2/SuperchainERC20.sol";
import {ISuperchainERC20} from "@contracts-bedrock/L2/interfaces/ISuperchainERC20.sol";

contract OpInteropToken is SuperchainERC20 {

    uint256 constant INITIAL_MINT = 1000e18;

    constructor() {
        _mint(msg.sender, INITIAL_MINT);
    }

    function name() public pure override returns(string memory) {
        return "Optimism";
    }

    function symbol() public pure override returns(string memory) {
        return "OP";
    }

    function mint(uint256 amount) public {
        _mint(msg.sender, amount);
    }

}

interface IOpInteropToken is ISuperchainERC20 {
    function mint(uint256 amount) external;
}
