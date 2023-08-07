// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract DegenGamingToken {
    string public name = "Degen Gaming Token";
    string public symbol = "DGN";
    uint8 public decimals = 18;
    uint256 public totalSupply;

    address public owner;
    mapping(address => uint256) public balanceOf;
    mapping(address => mapping(address => uint256)) public allowance;

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(address indexed owner, address indexed spender, uint256 value);
    event Mint(address indexed to, uint256 value);
    event Burn(address indexed from, uint256 value);

    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can perform this action");
        _;
    }

    constructor(uint256 initialSupply) {
        owner = msg.sender;
        totalSupply = initialSupply * (10**uint256(decimals));
        balanceOf[msg.sender] = totalSupply;
    }

    function mint(address to, uint256 value) external onlyOwner {
        require(to != address(0), "Invalid address");
        require(value > 0, "Invalid amount");
        balanceOf[to] += value;
        totalSupply += value;
        emit Mint(to, value);
    }

    function transfer(address to, uint256 value) external {
        require(to != address(0), "Invalid address");
        require(value > 0 && value <= balanceOf[msg.sender], "Invalid amount");
        balanceOf[msg.sender] -= value;
        balanceOf[to] += value;
        emit Transfer(msg.sender, to, value);
    }

    function approve(address spender, uint256 value) external {
        require(spender != address(0), "Invalid address");
        allowance[msg.sender][spender] = value;
        emit Approval(msg.sender, spender, value);
    }

    function transferFrom(address from, address to, uint256 value) external {
        require(from != address(0), "Invalid address");
        require(to != address(0), "Invalid address");
        require(value > 0 && value <= balanceOf[from], "Invalid amount");
        require(value <= allowance[from][msg.sender], "Allowance exceeded");
        balanceOf[from] -= value;
        balanceOf[to] += value;
        allowance[from][msg.sender] -= value;
        emit Transfer(from, to, value);
    }

    function redeem(uint256 value) external {
        require(value > 0 && value <= balanceOf[msg.sender], "Invalid amount");
        // Add your logic for redeeming tokens for in-game items here.
        // For simplicity, we'll just burn the tokens for demonstration purposes.
        balanceOf[msg.sender] -= value;
        totalSupply -= value;
        emit Burn(msg.sender, value);
    }

    function burn(uint256 value) external {
        require(value > 0 && value <= balanceOf[msg.sender], "Invalid amount");
        balanceOf[msg.sender] -= value;
        totalSupply -= value;
        emit Burn(msg.sender, value);
    }
    
    function checkBalance() external view returns (uint256) {
        return balanceOf[msg.sender];
    }
}
