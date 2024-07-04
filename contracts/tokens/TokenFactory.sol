// SPDX-License-Identifier: MIT
pragma solidity 0.8.19;
import "./TestERC20.sol";

contract TokenFactory {
    function createMintableToken(string memory name, string memory symbol, uint8 decimals, uint256 premintAmt) public returns(address){
        TestToken newToken = new TestToken(name, symbol, decimals);
        if(premintAmt > 0 ){
            newToken.mint(msg.sender, premintAmt);
        }
        return(address(newToken));
    }
}
