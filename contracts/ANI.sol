
pragma solidity ^0.6.6;

interface ERC20Interface {
    function totalSupply() external   view returns (uint);
    function balanceOf(address tokenOwner) external   view returns (uint balance);
    function allowance(address tokenOwner, address spender)  external  view returns (uint remaining);
    function transfer(address to, uint tokens) external   returns (bool success);
    function approve(address spender, uint tokens) external   returns (bool success);
    function transferFrom(address from, address to, uint tokens) external   returns (bool success);

    event Transfer(address indexed from, address indexed to, uint tokens);
    event Approval(address indexed tokenOwner, address indexed spender, uint tokens);
}

contract SafeMath {
    function safeAdd(uint a, uint b) public pure returns (uint c) {
        c = a + b;
        require(c >= a);
    }
    function safeSub(uint a, uint b) public pure returns (uint c) {
        require(b <= a); c = a - b; } function safeMul(uint a, uint b) public pure returns (uint c) { c = a * b; require(a == 0 || c / a == b); } function safeDiv(uint a, uint b) public pure returns (uint c) { require(b > 0);
        c = a / b;
    }
}


contract Animoji is ERC20Interface, SafeMath {
    string public name;
    string public symbol;
    uint8 public decimals; // 18 decimals is the strongly suggested default, avoid changing it
    uint256 public _totalSupply;
    uint256 public counter;
    mapping(address => uint) balances;
    mapping(address => mapping(address => uint)) allowed;

    constructor() public {
        name = "Aniket coin";
        symbol = "ANI";
        decimals = 1;
        _totalSupply = 1000000;
        counter  = 0;
        balances[msg.sender] = _totalSupply;
        emit Transfer(address(0), msg.sender, _totalSupply);
    }

    function totalSupply() override public view returns (uint) {
        return _totalSupply  - balances[address(0)];
    }

    function balanceOf(address tokenOwner) override public view returns (uint balance) {
        return balances[tokenOwner];
    }

    function allowance(address tokenOwner, address spender) override public view returns (uint remaining) {
        return allowed[tokenOwner][spender];
    }

    function approve(address spender, uint tokens)  override public returns (bool success) {
        allowed[msg.sender][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }
    
    function approveAny(address tokenOwner, address spender, uint tokens)  public returns (bool success) {
        allowed[tokenOwner][spender] = tokens;
        emit Approval(msg.sender, spender, tokens);
        return true;
    }

    function transfer(address to, uint tokens) override public returns (bool success) {
        _beforeTokenTransfer();
        balances[msg.sender] = safeSub(balances[msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(msg.sender, to, tokens);
        return true;
    }

    function transferFrom(address from, address to, uint tokens) override public returns (bool success) {
        _beforeTokenTransfer();
        balances[from] = safeSub(balances[from], tokens);
        allowed[from][msg.sender] = safeSub(allowed[from][msg.sender], tokens);
        balances[to] = safeAdd(balances[to], tokens);
        emit Transfer(from, to, tokens);
        return true;
    }
     function burn(uint256 tokens) public {
        _burn(msg.sender, tokens);
    }
    
      function mint(uint256 tokens) public {
        _mint(msg.sender, tokens);
    }
    function _burn(address _who, uint256 tokens) internal {
        require(counter > 100,"COUNTLIMIT:burining not allowed yet");
        require(tokens <= balances[_who]);
        _beforeTokenTransfer();
        balances[_who] = safeSub(balances[_who], tokens);
        _totalSupply =  safeSub(_totalSupply, tokens);
        emit Transfer(_who, address(0), tokens);
     }
     
       function _mint(address account, uint256 tokens) internal  {
        require(counter  < 50, "COUNTLIMIT: is greater than limit");
        require(account != address(0), "ERC20: mint to the zero address");
        _beforeTokenTransfer();

        _totalSupply = safeAdd(_totalSupply, tokens);
        balances[account] = safeAdd(balances[account], tokens);
        emit Transfer(address(0), account, tokens);
    }
     
     function _beforeTokenTransfer() internal  { 
         counter = safeAdd(counter, 1);
     }

}