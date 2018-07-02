pragma solidity ^0.4.18;

contract SCTFBank{
    event LogBalance(address addr, uint256 value);
    mapping (address => uint256) private balance;
    mapping (address => bool) private claimedBonus;
    uint256 private donation_deposit;
    address private owner;

    constructor() public{
        owner = msg.sender;
    }
    
    function showBalance(address addr) public {
        emit LogBalance(addr, balance[addr]);
    }

    function withdraw(uint256 value) public{
        require(balance[msg.sender] >= value);
        balance[msg.sender] -= value;
        msg.sender.transfer(value);

    }
    
    function transfer(address to, uint256 value) public {
        require(balance[msg.sender] >= value && balance[to]+value >= balance[to]);
        balance[msg.sender] -= value;
        balance[to]+=value;
    }

    function multiTransfer(address[] to_list, uint256 value) public {
	uint256 tmp = value*to_list.length;
	require(tmp / value == to_list.length);
        require(balance[msg.sender] >= (value*to_list.length));
        balance[msg.sender] -= (value*to_list.length);
        for(uint i=0; i < to_list.length; i++){
            require(balance[to_list[i]]+value >= balance[to_list[i]]);
            balance[to_list[i]] += value;
        }
    }
    
    function donate(uint256 value) public {
        require(balance[msg.sender] >= value);
        balance[msg.sender] -= value;
        require(donation_deposit+value >= donation_deposit);
        donation_deposit += value;

    }

    function deliver(address to) public {
    require(!claimedBonus[to]);
        require(msg.sender == owner);
        claimedBonus[to] = true;
        to.transfer(donation_deposit);
        donation_deposit = 0;
    }
    
    function () payable public {
        require(balance[msg.sender]+msg.value >= balance[msg.sender]);
        balance[msg.sender]+=msg.value;
    }
}
//END


