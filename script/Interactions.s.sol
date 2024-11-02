// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.25;

import {Script} from "lib/forge-std/src/Script.sol";
import {console} from "lib/forge-std/src/console.sol";
import {ISuperchainWETH} from "@contracts-bedrock/L2/interfaces/ISuperchainWETH.sol";
import {ISuperchainTokenBridge} from "@contracts-bedrock/L2/interfaces/ISuperchainTokenBridge.sol";
import {ISuperchainERC20} from "@contracts-bedrock/L2/interfaces/ISuperchainERC20.sol";
import {IOpInteropToken} from "src/OpInteropToken.sol";

contract Interactions is Script {
    
    address constant SUPERCHAIN_WETH = 0x4200000000000000000000000000000000000024;
    address constant SUPERCHAIN_TOKEN_BRIDGE = 0x4200000000000000000000000000000000000028;
    address constant OP_INTEROP_TOKEN = 0xdDC325B7b715e45f5fFA6F1BF5ED207e65F416A2;
    address payable receiver = payable(0x37a418800d0c812A9dE83Bc80e993A6b76511B57);
    uint256 constant CHAIN2_ID = 902;

    function run() public {
        uint256 amount = 1 ether;
        sendERC20ToOtherChain(OP_INTEROP_TOKEN, amount);
    }

    function sendEther() internal {
        uint256 privateKey = vm.envUint("ACCOUNT1_PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        
        (bool success, ) = receiver.call{value: 1 ether}("");
        require(success, "Transfer failed!");
        vm.stopBroadcast();
    }

    function sendERC20ToOtherChain(address token, uint256 amount) public {
        
        uint256 privateKey = vm.envUint("ACCOUNT1_PRIVATE_KEY"); 
        address to = getAccountAddress();
       
        vm.startBroadcast(privateKey);
        ISuperchainTokenBridge(SUPERCHAIN_TOKEN_BRIDGE).sendERC20(token, to, amount, CHAIN2_ID);
        vm.stopBroadcast();
    }

    function mintWETH() public {
        uint256 privateKey = vm.envUint("ACCOUNT1_PRIVATE_KEY"); 
        vm.startBroadcast(privateKey); 
        (bool success, ) = payable(SUPERCHAIN_WETH).call{value: 1 ether}("");
        require(success, "Transfer failed!");
        vm.stopBroadcast();
    }

    // Pure and View functions
    function getEthBalance() public view returns(uint256) {
        address account = getAccountAddress();
        uint256 amount = account.balance;
        console.log(amount);
        return amount;
    }

    function getBalanceOfWETH() public view returns(uint256) {
        address account = getAccountAddress();
        uint256 amount = ISuperchainWETH(SUPERCHAIN_WETH).balanceOf(account);
        console.log("Balance of WETH: ");
        console.log(amount);
        return amount;
    } 

    function getERC20TokenBalance(address token) public view returns(uint256) {
        return ISuperchainERC20(token).balanceOf(getAccountAddress());
    }

    // Internal 
    function getAccountAddress() internal view returns(address) {
        uint256 privateKey = vm.envUint("ACCOUNT1_PRIVATE_KEY"); 
        address account = vm.addr(privateKey);
        return account;
    }

    function mintERC20() internal {
        uint256 privateKey = vm.envUint("ACCOUNT1_PRIVATE_KEY"); 
        vm.startBroadcast(privateKey); 
        IOpInteropToken(OP_INTEROP_TOKEN).mint(2 ether);
        vm.stopBroadcast();
    }

}