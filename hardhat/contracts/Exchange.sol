//SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract  Exchange is ERC20 {

    address public cryptoDevTokenAddress;
    constructor(address _cryptoDevtoken) ERC20("CryptoDev LP tokens", "CDLP"){
        require(_cryptoDevtoken != address(0), "You should not enter null address");
        cryptoDevTokenAddress = _crytoDevtoken;
    }

    //to get eth reserve we use - address(this).balance;
    //to get cryptoDev token reserve - balanceOf(address(this))

    function getReserve() public view returns (uint256){
        return ERC20(cryptoDevTokenAddress).balanceOf(address(this));
    }

    function addLiquidity(uint _amount) public payable returns (uint256){
        uint liquidity;
        uint156 ethBalance = address(this).balance;
        uint256 cryptoDevsTokenReserve = getReserve();
        ERC20 cryptoDevToken = ERC20(cryptoDevTokenAddress);

        //if someone adds liquidity for the first time, there is no restriction on maintaining the ratio
        if(cryptoDevsTokenReserve == 0){
            cryptoDevToken.transferFrom(msg.sender, address(this), _amount);
            liquidity = ethBalance;
            _mint(msg.sender, liquidity);
        }

        //if you are adding liquidity later, it should always be in the ratio of eth/yourToken to not impact the price of your token
        if(cryptoDevsTokenReserve != 0){
            //to calculate the ratio
            uint256 ethReserve = ethBalance - msg.value;
            uint256 cryptoDevTokenAmount = (msg.value * cryptoDevsTokenReserve)/(ethReserve);
            require(_amount > cryptoDevsTokenAmount, "You do not have sufficient funds to provide liquidity");
            cryptoDevToken.transferFrom(msg.sender, address(this), cryptoDevTokenAmount);
            
            liquidity = (totalSupply()* msg.value)/ethReserve;
            _mint(msg.sender, liquidity); 
        }

        return liquidity;
    }

    //you can remove liquidity by burning the lp tokens you have and get the amount of eth and the token you put in liquidity pool
    function removeLiquidity(uint _amount) public returns (uint256, uint256){
        require(_amount > 0, "amount should be greater than zero");
        uint256 ethReserve = address(this).balance;
        uint256 _totalSupply = totalSupply();

        uint256 ethAmount = (ethReserve * _amount)/ _totalSupply;

        uint cryptoDevTokenAmount = (getReserve() * _amount)/ _totalSupply;

        _burn(msg.sender, _amount);

        payable(msg.sender).transfer(ethAmount);
        ERC20(cryptoDevTokenAddress).transfer(msg.sender, cryptoDevTokenAmount);
    }

    //getting amount of tokens using the formula x*y = constant when you try to swap tokens assuming that you pay 1% fees
    function getAmountOfTokens(
    uint256 inputAmount,
    uint256 inputReserve,
    uint256 outputReserve
) public pure returns (uint256) {
    require(inputReserve > 0 && outputReserve > 0, "invalid reserves");
    uint256 inputAmountWithFee = inputAmount * 99;
    uint256 numerator = inputAmountWithFee * outputReserve;
    uint256 denominator = (inputReserve * 100) + inputAmountWithFee;
    return numerator / denominator;
}

//swap functions

}