// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract MultiSigWallet {

    enum TransactionStatus {
        PENDING ,
        APPROVED,
        REJECTED
    }

    TransactionStatus public statusOfTxn;

    event ApproveTransaction(address indexed initiator, string message);
    event RejectTransaction(address indexed initiator, string message);
    event ExecuteTransaction(address indexed initiator, string message);


    address payable[] public walletGroupOwners;
    mapping(address => bool) public isOwner;
    mapping(address => mapping(uint => TransactionStatus)) public memberApprovalStatus;
    address payable public pendingTransaction;
    uint public approvalCount;



    constructor(address payable[] memory _walletGroupOwners) {
       for (uint8 i = 0; i < _walletGroupOwners.length; i++) {
            require(_walletGroupOwners[i] != address(this), "Smart Contract Address cannot be part of the Owners");
            walletGroupOwners.push(_walletGroupOwners[i]);
            isOwner[_walletGroupOwners[i]] = true; // Mark the address as an owner
        }
        statusOfTxn = TransactionStatus.PENDING;
    
    }


    modifier basicChecksForTxn (){
        require(isOwner[msg.sender] , "This address is not part of the Owners Group ");
        require(msg.sender != address(this) , "The smart contract is not Allowed to call this function");
        _;
    }

    function getContractBalance () view  public returns(uint256 _contractBalance){
        return address(this).balance;

    }


    function sumbitTransaction (address payable _receiver, uint _amount) basicChecksForTxn public  {
       require(statusOfTxn == TransactionStatus.PENDING , "Txn must either be Approved or Rejected");
       require(address(this).balance > _amount, "smart contract doesn not have enough funds for this amount .. use an amount lower than that of the smart contract balance ");
       require(_receiver != address(0), "Should not be a 0x0  address");
       require(approvalCount < walletGroupOwners.length, "approval count should be lower than Owner Group" );
       pendingTransaction = _receiver;
       memberApprovalStatus[msg.sender][approvalCount] = TransactionStatus.PENDING;
       approvalCount = approvalCount + 1;

       statusOfTxn = TransactionStatus.PENDING;
       emit ApproveTransaction(msg.sender, "new txn submitted.... only one party approves .. ");
         
    
    }



    function approvalOfSubmittedTxn() basicChecksForTxn public {
         require(statusOfTxn == TransactionStatus.PENDING , "Txn must either be Approved or Rejected");
         require(memberApprovalStatus[msg.sender][approvalCount] == TransactionStatus.PENDING, "this address has already approved or rejected ");
         
         memberApprovalStatus[msg.sender][approvalCount] = TransactionStatus.APPROVED;
         approvalCount ++;

         if(approvalCount == (walletGroupOwners.length / 2) + 1){
             executeApprovedTxn();
         }

        
        emit ApproveTransaction(msg.sender, "transaction is approved ");
    }

    function executeApprovedTxn() basicChecksForTxn internal {
      require(statusOfTxn == TransactionStatus.PENDING , "Txn must either be Approved or Rejected");
      
      uint256 balance = address(this).balance;
      (bool success, ) = pendingTransaction.call{value:balance}("");
       require(success, "FAILED EXECUTION");
        statusOfTxn = TransactionStatus.APPROVED;
        approvalCount = 0;
        pendingTransaction = payable(address(0));

        emit ExecuteTransaction(msg.sender, "EXECUTION COMPLETE");


    }

    function rejectedTransaction () basicChecksForTxn public {
       require(statusOfTxn == TransactionStatus.PENDING , "Txn must either be Approved or Rejected");
       require(approvalCount < walletGroupOwners.length, "approval count should be lower than Owner Group" );
     require(memberApprovalStatus[msg.sender][approvalCount] == TransactionStatus.PENDING, "this address has already approved or rejected ");
       memberApprovalStatus[msg.sender][approvalCount] = TransactionStatus.REJECTED;
      emit RejectTransaction(msg.sender, "This party does not approve");

    }




}


// submit a transaction
//approve and revoke approval of pending transactions
//anyone can execute a transaction after enough owners has approved it.