// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

interface IERC20Permit {
  function totalSupply() external view returns (uint256);
  function balanceOf(address account) external view returns(uint256);
  function transfer(address recipient, uint256 amount ) external returns (bool);
  function allowance(address _owner, address _spender) external view returns (uint256 remaining);
  function approve(address _spender, uint256 _value) external returns (bool success);
  function transferFrom(address _from, address _to, uint256 _value) external returns (bool success);
  event Approval(address indexed _owner, address indexed _spender, uint256 _value);
  function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
  event Transfer(address indexed _from, address indexed _to, uint256 _value);
}