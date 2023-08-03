// SPDX-License-Identifier:GPL-3.0
pragma solidity>=0.5.0<0.9.0;
interface ERC_20_token
{
    function total_supply() external view returns(uint);
    function balance_of(address token_owner) external view returns(uint);
    function transfer(address to , uint tokens) external returns(bool success);

    function allowance(address token_owner , address spender) external view returns(uint remaining);
    function approve(address spender , uint tokens) external returns(bool success);
    function transfer_from(address from , address to , uint tokens) external returns(bool success);

    function decimals() external view returns(uint);

    event Transfer(address indexed from , address indexed to , uint tokens);
    event Approval(address indexed token_owner , address indexed spender , uint tokens);
}

contract ERC is ERC_20_token 
{
  string public token_name = "PLATINUM";
  string public symbol = "PLTM";
  uint public decimal=18 ;
  uint public override total_supply;

  address public minter;
  mapping(address=>uint) public balances;
  mapping(address=>mapping(address=>uint)) allowed;

  constructor(uint _total_supply)
  {
      minter =msg.sender;
      total_supply=_total_supply;
      balances[msg.sender]=total_supply;
  }

  function balance_of(address token_owner) external view override returns(uint)
  {
    return balances[token_owner];
  }

  function transfer(address to , uint tokens) external override returns(bool success)
  {
      require(balances[msg.sender]>=tokens,"you dont have enough tokens");
      balances[msg.sender]-=tokens;
      balances[to]+=tokens;
      emit Transfer(msg.sender,to,tokens);
      return true;
  }

  function allowance(address token_owner , address spender) external view override returns(uint remaining)
  {
     return allowed[token_owner][spender];
  }

  function approve(address spender , uint tokens) external override returns(bool success)
  {
      require(balances[msg.sender]>=tokens,"you dont have enough tokens");
      require(tokens>0,"send more than 0 tokens");
      allowed[msg.sender][spender]=tokens;
      emit Approval(msg.sender, spender, tokens);
      return true;
  }

  function transfer_from(address from , address to , uint tokens) external override returns(bool success)
  {
     require(allowed[from][to]>=tokens,"don't have enough tokens");
     require(balances[from]>=tokens,"the person who gave approval has not much tokens");
     balances[from]-=tokens;
     balances[to]+=tokens;
     return true;
  }
   function decimals() external pure override returns(uint)
   {
       return 18;
   }

   function burn_tokens(uint value) public 
   {
       require(minter==msg.sender,"only minter can burn tokens");
       require(balances[msg.sender]>=value,"don't have enough tokens");
       total_supply-=value;
       balances[msg.sender]-=value;
   }
  
  }