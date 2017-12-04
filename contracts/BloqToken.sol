pragma solidity ^0.4.4;

import 'zeppelin-solidity/contracts/token/StandardToken.sol';
import 'zeppelin-solidity/contracts/lifecycle/Pausable.sol';
import "./Whitelist.sol";

contract BloqToken is StandardToken, Pausable {

	string public name = 'TutorialToken';
	string public symbol = 'TT';
	uint public decimals = 0;
	
	uint[] public cap = [0, 100, 1000];
	Whitelist public wl;

	function BloqToken(uint256 _initialSupply, address _whitelist) public {
	  totalSupply = _initialSupply;
	  balances[msg.sender] = _initialSupply;
	  wl = Whitelist(_whitelist);
	}
	
	modifier validateTransfer(address _to, uint256 _value) {
		uint balance = balances[_to].add(_value);
		require(balance <= cap[wl.tierOf(_to)]);
		_;
	}
	
	/**
	   * @dev Transfer tokens from one address to another by the owner
	   * @param _from address The address which you want to send tokens from
	   * @param _to address The address which you want to transfer to
	   * @param _value uint256 the amount of tokens to be transferred
	*/
	function transferFromByOwner(address _from, address _to, uint256 _value) public onlyOwner whenNotPaused validateTransfer(_to, _value) returns (bool) {
		require(_to != address(0));
		require(_value <= balances[_from]);

		balances[_from] = balances[_from].sub(_value);
		balances[_to] = balances[_to].add(_value);
		Transfer(_from, _to, _value);
		return true;
	}
	
	function transfer(address _to, uint256 _value) public whenNotPaused validateTransfer(_to, _value) returns (bool) { return super.transfer(_to, _value); }
	function transferFrom(address _to, uint256 _value) public whenNotPaused validateTransfer(_to, _value) returns (bool) { return super.transfer(_to, _value); }
	function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) { return super.approve(_spender, _value); }
	function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) { return super.increaseApproval(_spender, _addedValue); }
	function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) { return super.decreaseApproval(_spender, _subtractedValue); }

}
