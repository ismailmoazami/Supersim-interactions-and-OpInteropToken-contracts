// SPDX-Licence-Identifier: MIT
pragma solidity 0.8.25;

import {Script} from "lib/forge-std/src/Script.sol";
import {OpInteropToken} from "src/OpInteropToken.sol";

contract DeployToken is Script {
    
    function run() public returns(OpInteropToken) {
        uint256 privateKey = vm.envUint("ACCOUNT1_PRIVATE_KEY");
        vm.startBroadcast(privateKey);
        OpInteropToken op_token = new OpInteropToken{salt: "token"}();
        vm.stopBroadcast();
        return op_token;
    }
}