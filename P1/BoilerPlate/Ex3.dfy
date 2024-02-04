
module Ex3 {


class Node {

  var data : int 
  var next : Node? 

  ghost var list : seq<int>
  ghost var footprint : set<Node>

  ghost function Valid() : bool 
    reads this, footprint
    decreases footprint
  {
    (this in footprint) &&
    ((next == null) ==> list == [ data ] && footprint == { this }) &&
    ((next != null) ==> 
      (next in footprint) && 
      footprint == next.footprint + { this } && 
      (this !in next.footprint) &&
      list == [ data ] + next.list &&
      next.Valid())
  }

  constructor (val : int) 
    ensures Valid() 
      && next == null && list == [ data ] 
      && footprint == { this } 
      && val == data 
  {
    this.data := val; 
    this.next := null; 
    this.list := [ val ]; 
    this.footprint := { this };
  } 

  method prepend (val : int) returns (r : Node)
    requires Valid()
    ensures r.Valid()
    ensures r.list == [ val ] + this.list
    ensures r.footprint == { r } + this.footprint
    ensures fresh(r) 
  {
    r := new Node(val); 
    r.next := this; 
    r.footprint := { r } + this.footprint; 
    r.list := [ val ] + this.list;  
    return; 
  }



  method PrintList()
  requires Valid()
  decreases footprint
  {
    print data;
    if (next != null) {
        print " -> ";
        next.PrintList();
    } else {
        print "\n";
    }
  }

// Ex 1
  method reverseN(tail: Node?) returns (r: Node)
      requires Valid()
      requires tail != null ==> tail.Valid()
      requires (tail != null ==> this !in tail.footprint)
      requires (tail != null ==> (this.footprint * tail.footprint) == {})
      ensures tail == this.next
      ensures (tail != null ==> r.list == reverse(old(this.list)) + tail.list)
      ensures (tail == null ==> r.list == reverse(old(this.list)))
      ensures (tail != null ==> next.Valid() && tail in footprint)
      ensures r.Valid()
      modifies footprint
      decreases footprint
    {
      var old_next := this.next;
      this.next := tail;

      if(tail != null){
        this.footprint := {this} + tail.footprint;
        this.list := [this.data] + tail.list;
      }
      else{
        this.footprint := {this};
        this.list := [this.data];
      }

      assert this.Valid();
      
      if (old_next == null) {
          r := this;
          return;
      } else {
          assert old_next.Valid();
          r := old_next.reverseN(this);
          assert r.Valid();
          return;
      }
    }

} // end of class Node

  function reverse(s: seq<int>) : seq<int>
  { 
  if(s == []) then []
  else reverse(s[1..]) + [s[0]]
  }

  // Ex2
    method ExtendList(nd: Node?, v: int) returns (r: Node)
    requires nd == null || nd.Valid()
    ensures r.Valid() && r.data == v
    ensures r.next == nd
    ensures fresh(r)
    ensures r.list == [v] + (if(nd == null) then [] else nd.list)
    ensures r.footprint == {r} + (if(nd == null ) then {} else nd.footprint)
{
    r := new Node(v);
    r.next := nd;
    if (nd != null) {
        r.list := [v] + nd.list;
        r.footprint := {r} + nd.footprint;
    }
}

 method Main() 
  {
    
    // Test 1: Enunciado
    var n1 := new Node(1);
    var n2 := n1.prepend(2);
    var n3 := n2.prepend(2);

    n3.PrintList();

    var reversed := n3.reverseN(null);

    reversed.PrintList();

  }
}
