include "Ex3.dfy"


module Ex4 {


import Ex3=Ex3

class Queue {

  //lst1 -> head
  //lst2 -> tail
  var lst1 : Ex3.Node?
  var lst2 : Ex3.Node?

  ghost var footprint: set<Ex3.Node>
  ghost var vs: multiset<(int)>

  ghost function ValidQ() : bool
     reads this, lst1 , if lst1 == null then {} else lst1.footprint
     reads lst2, footprint , if lst2 == null then {} else lst2.footprint
  {
      (lst1 != null && lst2 == null ==> this.footprint == lst1.footprint && lst1.Valid() && vs ==  multiset(lst1.list))
      &&
      (lst1 == null && lst2 != null ==> this.footprint == lst2.footprint && lst2.Valid() && vs ==  multiset(lst2.list))
      && 
      (lst1 == null && lst2 == null ==> this.footprint == {} && vs == multiset{})
      &&
      (lst1 != null && lst2 != null ==>  this.footprint == lst1.footprint && lst1.Valid() && lst2.Valid() && vs ==  multiset(lst1.list))
  }

  // Ex2 
  constructor ()
    ensures ValidQ() 
    ensures lst1 == null && lst2 == null && footprint == {} && vs == multiset{}
  {
    this.lst1 := null; 
    this.lst2 := null;  
    this.footprint := {};
    this.vs := multiset{};
  } 

  // Ex3.1
  method push(val : int)
    requires ValidQ() && val >= 0
    ensures lst1 != null ==> lst1.Valid() 
    ensures  lst2 == null ==> this.footprint >= old(this.footprint)
    ensures  old(lst1) != null ==> vs ==  multiset(old(lst1.list) + [val])
    ensures  lst1 != null ==> this.footprint == lst1.footprint 
    ensures  lst1 == null ==> this.vs == multiset{}
    ensures  ValidQ() 
    
    modifies this
  {
    lst1 := Ex3.ExtendList(lst1, val);
    assert lst1.Valid();
    this.footprint :=  lst1.footprint;
    vs := multiset(this.lst1.list) ;  
  }

  // Ex3.2
  method pop() returns (r : int)
    requires ValidQ()
    requires footprint != {}
    requires lst2 == lst1
    ensures ValidQ()
    modifies this, lst1, lst2, footprint
  {

    if (lst2 == null) {
      lst2 := lst1.reverseN(null); 
      lst1 := null;
      assert lst1 == null;
      assert lst2 != null;
      footprint := lst2.footprint;
      vs := multiset(this.lst2.list) - multiset{r};
    }
    r := lst2.data; 
    lst2 := lst2.next; 
  }
  
}
}