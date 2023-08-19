//SPDX-License-Identifier:GPL-3.0
pragma solidity>=0.5.0<0.9.0;
import "@openzeppelin/contracts/token/ERC20/ERC20.sol";
 contract whiskey_token is ERC20
{

  string public token_name;
  string public token_symbol;
  uint256 public totalWhiskyTokensSupply; //whisky tokens total supply
  

//  structure of the cask or barrel created by cask_owner sale
    struct cask 
    {
        uint cask_id;    //unique cask id
        address cask_owner;   //address of the cask owner
        string cask_type_name; //name of type of the cask
        bool refilled_cask;   // cask is refilling or filled first time
        uint total_casks_supplying; //total no. of casks supplied by owner
        uint Total_fractions;   //total fractions in which casks are divided
        uint purchased_fractions;  //amount of fractions purchased 
        uint Available_fractions;  // amount of fractions left
        uint per_fraction_price;  // price of one fraction of cask
        uint invested_amount;  //total invested amount in the cask
    }

    struct cask_on_sell
    {
       uint cask_id;   // unique cask id which is on sell
       uint seller_id;  //unique seller id
       string cask_type_name; //name of type of the cask
       address fraction_owner; // address of fractions owner
       uint fractions_for_sell; //number of fractions to list on sell
       uint price_per_fraction; // price of one fraction 
    }
    
    uint next_cask_id=1 ; //cask_id initializing from 1
    uint next_seller_id=1 ; //seller_id initializing from 1
    bool self_destruct ;  // making self_destruct variable in case of cask is destroyed

    mapping(address=>bool) public is_investor;  //making mapping for checking that address is an investor or not
    mapping(uint=>cask) public Casks;  //making mapping from uint to cask to store details of casks
    mapping(address=>uint[]) public casks_ids_you_invest;  //making mapping from address to dynamic array for knowing in which cask id's you invested
    mapping(address=>mapping(uint=>uint)) public num_of_fractions_of_cask; //nested mapping for numbers of fractions of cask addresses have
    mapping(uint=>cask_on_sell) public casks_for_sell; // mapping from unique seller id to structure cask_on_sell
    mapping(uint=>bool) public is_cask_destroyed; //mapping for checking that the cask is destroyed or not
    mapping(uint=>cask) public casks_destroyed; //mapping to store details of destroyed casks

    // modifier which is only called by investor 
    modifier only_investor() 
    {
      require(is_investor[msg.sender]==true,"you are not at investor");_;
    }
    
    // modifier to check cask is destroyed or not
    modifier cask_destroyed()
    {
      require(self_destruct==false,"cask is destroyed");_;
    }
    
     constructor() ERC20("Whiskey Token", "WHT") {
        token_name = "Whiskey Token";
        token_symbol = "WHT";   
    }

     // event for cask creation 
     event cask_created(uint _cask_id , address cask_owner,uint _total_casks_supplying,uint _total_fractions,uint _per_fraction_price);
     
     //function for creating cask 
     function create_cask(string calldata _cask_type_name , bool _refilled_cask , uint _total_casks_supplying , uint _total_fractions , uint _per_fraction_price) external
     {
       require( _total_casks_supplying>0 && _total_fractions>0 && _per_fraction_price>0, "total casks supplying , total fractions of casks and price per fraction must be greater than zero" ); //checking total casks supplying , total fractions of casks and price per fraction must be greater than zero
       Casks[next_cask_id]=cask(next_cask_id,msg.sender,_cask_type_name,_refilled_cask,_total_casks_supplying,_total_fractions,0,_total_fractions,_per_fraction_price,0); //storing details of that cask
       casks_ids_you_invest[msg.sender].push(next_cask_id);//pushing the unique cask id number in the array of the address 
       num_of_fractions_of_cask[msg.sender][next_cask_id]=_total_fractions; // assigning all fractions to the cask creator address initially
       is_investor[msg.sender]=true; // making is_investor of the address true
       totalWhiskyTokensSupply += _total_fractions; //adding total whisky tokens supply
       emit cask_created(next_cask_id, msg.sender, _total_casks_supplying, _total_fractions, _per_fraction_price); //emitting the cask creation event
       next_cask_id++; //increasing cask_id by 1
     }

       //list of casks and its details created by its owners
       function list_of_cask_fractions_created_by_cask_owners() public view returns(cask[] memory)
    {
        cask[] memory arr = new cask[](next_cask_id-1);

        for(uint i =1 ; i<next_cask_id;i++) 
        {
            arr[i-1]=Casks[i];
        }

        return arr;
    }

     //event for checking fractions are purchased or not
     event fractions_purchased(uint _cask_id_you_buy , uint num_of_fractions_you_buy , uint money_spent);

     //function for buying cask fractions 
     function buy_cask_fractions(uint _cask_id_to_buy , uint num_of_fractions_to_buy) external payable cask_destroyed()
     {
       
       require(_cask_id_to_buy>0 && _cask_id_to_buy<next_cask_id,"enter valid cask id to buy.."); //cask id must be bewtween 0 to next_cask_id
       require(num_of_fractions_to_buy>0 && num_of_fractions_to_buy<=Casks[_cask_id_to_buy].Available_fractions,"purchase more than 0 fractions OR not much fractions are available"); //fractions to buy should be less than available fractions and more than 0
       require(msg.value==(Casks[_cask_id_to_buy].per_fraction_price*num_of_fractions_to_buy),"insufficient balance"); //money sent should be correct
       num_of_fractions_of_cask[msg.sender][_cask_id_to_buy]+=num_of_fractions_to_buy; //increasing number of fractions in cask's address
       num_of_fractions_of_cask[Casks[_cask_id_to_buy].cask_owner][_cask_id_to_buy]-=num_of_fractions_to_buy; //decreasing number of fractions in cask owner's address
       casks_ids_you_invest[msg.sender].push(_cask_id_to_buy); //pushing the cask id which address has purchased
       Casks[_cask_id_to_buy].purchased_fractions+=num_of_fractions_to_buy; //increasing purchased fractions of cask 
       Casks[_cask_id_to_buy].Available_fractions-=num_of_fractions_to_buy; //decreasing number of available fractions of cask 
       Casks[_cask_id_to_buy].invested_amount+=msg.value; //increasing invested amount of cask 
       payable(Casks[_cask_id_to_buy].cask_owner).transfer(msg.value); //transferring money to cask owner
       is_investor[msg.sender]=true; //making is investor true
      //  checking if all cask fractions are sold than the cask owner will not be an investor
       if(num_of_fractions_of_cask[Casks[_cask_id_to_buy].cask_owner][_cask_id_to_buy]==0)
       {
         is_investor[Casks[_cask_id_to_buy].cask_owner]=false;
       }
       emit fractions_purchased(_cask_id_to_buy, num_of_fractions_to_buy, msg.value); //emitting fractions purchased event 
     }

    //event for checking fractions listed for sell
    event fractions_listed_for_sell(uint _cask_id,uint _fractions_for_sell,uint _price_per_fraction);

    //function for fractions listed on sell
    function fraction_for_sell(uint _cask_id,string calldata _cask_type_name,uint _fractions_for_sell,uint _price_per_fraction) external only_investor()
    { 
      require(num_of_fractions_of_cask[msg.sender][_cask_id]>=_fractions_for_sell && _fractions_for_sell>0,"you don't have enough fractions"); //number of fractions of msg.sender should be more than fractions for sell 
      casks_for_sell[next_seller_id]=cask_on_sell(_cask_id,next_seller_id,_cask_type_name,msg.sender,_fractions_for_sell,_price_per_fraction); //storing details of cask seller
      emit fractions_listed_for_sell(_cask_id, _fractions_for_sell, _price_per_fraction); //emitting fractions_listed_for_sell event
      next_seller_id++; //increasing seller id by 1
    }

    // function for watching list of fractions on sell
    function list_of_fractions_on_sell() public view returns (cask_on_sell[] memory) 
    {
    cask_on_sell[] memory arr = new cask_on_sell[](next_seller_id);

    for (uint i = 1; i < next_seller_id; i++) 
    {
        arr[i] = casks_for_sell[i];
    }
    return arr;
    }
    
    // event for fractions purchased from sell
    event purchased_fractions_from_sell(uint _cask_id_to_buy , uint _num_of_fractions_to_buy , uint _seller_id , uint money_spent) ;
    
    //function for buying fractions from sell
    function buy_fractions_from_sell(uint _cask_id_to_buy , uint _num_of_fractions_to_buy , uint _seller_id) public payable cask_destroyed()
    {
       require(_seller_id>=1 && _seller_id<next_seller_id,"enter valid seller id...");  //seller id should be valid
       require(casks_for_sell[_seller_id].cask_id==_cask_id_to_buy,"seller don't has this cask type"); //cask id should be valid and also on sell
       require(_num_of_fractions_to_buy<=casks_for_sell[_seller_id].fractions_for_sell,"seller don't have enough fractions"); //seller have enough fractions for sell
       require(msg.value==(_num_of_fractions_to_buy*casks_for_sell[_seller_id].price_per_fraction),"not sufficient funds"); //money sent should be proper
       require(num_of_fractions_of_cask[casks_for_sell[_seller_id].fraction_owner][_cask_id_to_buy]>=_num_of_fractions_to_buy,"not enough fractions");//seller have enough fractions for sell
       num_of_fractions_of_cask[msg.sender][_cask_id_to_buy]+=_num_of_fractions_to_buy; //increasing number of fractions in buyer's account
       num_of_fractions_of_cask[casks_for_sell[_seller_id].fraction_owner][_cask_id_to_buy]-=_num_of_fractions_to_buy; //decreasing fractions from seller's account
       casks_for_sell[_seller_id].fractions_for_sell-= _num_of_fractions_to_buy; //also updating it in casks_for_sell structure
       payable(casks_for_sell[_seller_id].fraction_owner).transfer(msg.value); //transferring money to fractions owner
       emit purchased_fractions_from_sell(_cask_id_to_buy, _num_of_fractions_to_buy, _seller_id,msg.value); //emiiting purchased_fractions_from_sell event
       //  checking if all cask fractions are sold than the seller will not be an investor
       if(num_of_fractions_of_cask[casks_for_sell[_seller_id].fraction_owner][_cask_id_to_buy]==0)
       {
           is_investor[casks_for_sell[_seller_id].fraction_owner]=false;
       }
       casks_ids_you_invest[msg.sender].push( _cask_id_to_buy); //inserting cask id in buyer's address
       is_investor[msg.sender]=true;//making is investor true
    }

    //making event for fractions_transferred
    event fractions_transferred(address sender , address _to , uint _num_of_fractions , uint _cask_id);

    //function for transferring fractions
    function transfer_fractions(address _to_transfer , uint _num_of_fractions , uint _cask_id) public only_investor()
    {
       require(_cask_id>0 && _cask_id<next_cask_id,"Invalid cask id"); //cask id should be valid
       require(num_of_fractions_of_cask[msg.sender][_cask_id]>=_num_of_fractions && _num_of_fractions>0,"you dont have enough fractions"); // address should have enough fractions for sell
       num_of_fractions_of_cask[_to_transfer][_cask_id]+=_num_of_fractions; //increasing number of fractions in receiver's account
       num_of_fractions_of_cask[msg.sender][_cask_id]-=_num_of_fractions; //decreasing number of fractions in address account who transfer tokens 
       is_investor[_to_transfer]=true;   ////making is investor true for receiver's account
       casks_ids_you_invest[_to_transfer].push(_cask_id); //inserting cask id in receiver's address
       //  checking if all cask fractions are transferred than the person who transferred tokens will not be an investor
       if(num_of_fractions_of_cask[msg.sender][_cask_id]==0)
       {
           is_investor[msg.sender]=false;
       }
       emit fractions_transferred(msg.sender,_to_transfer, _num_of_fractions , _cask_id); //emitting fractions transferred event
    }

    //function for cancel listing of fractions on sell
    function cancel_sell_listing(uint _seller_id) external only_investor()
    {
      require(casks_for_sell[_seller_id].fraction_owner==msg.sender,"you are not owner"); //only seller who lsited fractions on sell can call the function
      delete casks_for_sell[_seller_id]; //deleting the listing
    }

    //function for updating the price of the cask fractions by cask owner
    function update_fraction_price_of_cask(uint _cask_id , uint _updated_price) public  only_investor() 
    {
      require(_cask_id>0 && _cask_id<next_cask_id,"invalid cask id"); //cask id should be valid
      require(Casks[_cask_id].cask_owner==msg.sender,"you are not the owner of the cask"); //only cask owner can update the price
      Casks[_cask_id].per_fraction_price=_updated_price; //updating the price
    }

    //function if the cask is destroyed 
    function destory_cask(uint _cask_id) public payable
    {
      require(msg.sender.balance>=(Casks[_cask_id].invested_amount),"you must have invested amount to destroy the cask,its your responsibility to return all investors money");//address balance should be greater than total invested amount only than the cask can be destroyed
      require(msg.value>=(Casks[_cask_id].invested_amount),"send valid money");
      require(Casks[_cask_id].cask_owner==msg.sender,"you are not the owner of the cask"); //only cask owner can call this function
      is_cask_destroyed[_cask_id]=true; //  making is_cask_destroyed of that cask id true
      casks_destroyed[_cask_id]=Casks[_cask_id]; //storing destroyed casks details in another mapping 
      totalWhiskyTokensSupply -=Casks[_cask_id].Total_fractions;//decreasing num of tokens from total supply after cask is destroyed
      delete (Casks[_cask_id]); //deleting that cask
    }

    //making the event fractions redeemed   
    event fractions_redeemed(address investor_redeemed , uint fractions_redeemed);
   
    // making the function redeem_fractions_of_destroyed_cask so investor can get their money by cask owner if the cask is destroyed
function redeem_fractions_of_destroyed_cask(uint _cask_id) public only_investor() {
    require(is_cask_destroyed[_cask_id] == true, "cask is not destroyed"); // checking that the cask is destroyed or not
    require(num_of_fractions_of_cask[msg.sender][_cask_id] > 0, "you don't have fractions of this cask"); // msg.sender has that cask fractions or not
    
    uint redemptionAmount = casks_destroyed[_cask_id].per_fraction_price * num_of_fractions_of_cask[msg.sender][_cask_id];
    require(address(this).balance >= redemptionAmount, "Contract balance is insufficient for redemption"); // checking if contract balance is enough
    
    num_of_fractions_of_cask[msg.sender][_cask_id] = 0; // number of fractions after withdrawing the money of destroyed cask should be 0
    
    // Deduct redeemed amount from cask owner's account and transfer to the investor
    payable(msg.sender).transfer(redemptionAmount);
    
    emit fractions_redeemed(msg.sender, num_of_fractions_of_cask[msg.sender][_cask_id]); // emitting fractions_redeemed event
}


}