datatype Tree<V> = Leaf(V) | SingleNode(V, Tree<V>) | DoubleNode(V, Tree<V>, Tree<V>)

datatype Code<V> = CLf(V) | CSNd(V) | CDNd(V)


function serialise<V>(t : Tree<V>) : seq<Code<V>> 
  decreases t 
{
  match t {
    case Leaf(v) => [ CLf(v) ]
    case SingleNode(v, t) => serialise(t) + [ CSNd(v) ]
    case DoubleNode(v, t1, t2) => serialise(t2) + serialise(t1) + [ CDNd(v) ]
  }
}

// Ex 1

/*

DoubleNode(1, Leaf(2), SingleNode(3, DoubleNode(4, Leaf(5), Leaf(6)))
== serialise
output: [CLf(6), CLf(5), CDNd(4), CSNd(3), CLf(2), CDNd(1)]


tree: 1
     / \
    2   3
        |
        4
       / \
      5   6
*/

function deserialise<V>(cs: seq<Code<V>>):seq<Tree<V>>
  requires |cs| > 0
{
  deserialiseAux(cs,[])
}

function deserialiseAux<V>(cs: seq<Code<V>>, trees: seq<Tree<V>>): seq<Tree<V>>
  ensures |deserialiseAux(cs,trees)| > 0
  decreases cs
  requires |trees| > 0 || |cs| > 0
{
  if(cs == []) then trees
  else deserialiseAux(cs[1..], deserialiseAux2(cs[0],trees))
}



function deserialiseAux2<V>(c: Code<V>, trees: seq<Tree<V>>) : seq<Tree<V>>
{
   match c {
    case CLf (v) => [ Leaf(v) ] + trees
    case CSNd(v) => 
      if (|trees| < 1) then [Leaf(v) ] 
      else [SingleNode (v, trees[0])] + trees[1..]
    case CDNd(v) => 
      if (|trees| < 2) then [ Leaf(v) ]
      else [DoubleNode (v, trees[0], trees[1])] + trees[2..]  
  }
}

// Ex 2

method TestSerialise() {

  // multiple single nodes
  var testTree := SingleNode(1, SingleNode(2, SingleNode(3, Leaf(4))));
  assert serialise(testTree) == [CLf(4), CSNd(3), CSNd(2), CSNd(1)];

  // Alternative patterns
  var mixTree := DoubleNode(1, SingleNode(2, Leaf(3)), SingleNode(4, Leaf(5)));
  assert serialise(mixTree) == [CLf(5), CSNd(4), CLf(3), CSNd(2), CDNd(1)];

  // multiple double nodes
  var dTree := DoubleNode(1, SingleNode(2, DoubleNode(3, Leaf(4), Leaf(5))), DoubleNode(6, Leaf(7), Leaf(8)));
  assert serialise(dTree) == [CLf(8), CLf(7), CDNd(6), CLf(5), CLf(4), CDNd(3), CSNd(2), CDNd(1)];
}


// Ex 3
method TestDeserialise() {

  // multiple single nodes
  var testSeq := [CLf(4), CSNd(3), CSNd(2), CSNd(1)];
  assert deserialise(testSeq) == [SingleNode(1, SingleNode(2, SingleNode(3, Leaf(4))))];

  // Alternative patterns 
  var mixSeq := [CLf(5), CSNd(4), CLf(3), CSNd(2), CDNd(1)];
  assert deserialise(mixSeq) == [DoubleNode(1, SingleNode(2, Leaf(3)), SingleNode(4, Leaf(5)))];


  // multiple double nodes
  var dSeq := [CLf(8), CLf(7), CDNd(6), CLf(5), CLf(4), CDNd(3), CSNd(2), CDNd(1)];
  assert deserialise(dSeq) == [DoubleNode(1, SingleNode(2, DoubleNode(3, Leaf(4), Leaf(5))), DoubleNode(6, Leaf(7), Leaf(8)))];
}



//Ex 4 
// Prove that deserialise is the inverse of serialise

/**lemma SerialiseLammaAux<V>(t : Tree<V>, v : seq<Code<V>>)
  ensures deserialise(serialise(t) + [CDNd(v)]) == t
**/

 
lemma SerialiseLemmaAux<T>(t : Tree<T>, cs : seq<Code<T>>, ts : seq<Tree<T>>)
  ensures deserialiseAux(serialise(t) + cs,ts) == deserialiseAux(cs, [t] + ts)
{
   match t {
     case Leaf(v) =>
       // Base case for Leaf
       calc == {
         deserialiseAux(serialise(Leaf(v)) + cs, ts);
       == //definition of serialise for Leaf
         deserialiseAux([CLf(v)]+cs,ts);
       == //definition of deserialise
         deserialiseAux(cs, deserialiseAux2(CLf(v),ts));
       ==
        deserialiseAux(cs, [Leaf(v)] + ts);
       }

     case SingleNode(v, t) =>
        assert serialise(t) + [ CSNd(v) ] + cs == serialise(t) + ([ CSNd(v) ] + cs);
       // Inductive case for SingleNode
       calc == {
          deserialiseAux(serialise(t) + [CSNd(v)] + cs,ts); 
        ==
          deserialiseAux(serialise(SingleNode(v,t)) + cs,ts);
        ==
          deserialiseAux(cs, [SingleNode(v,t)] + ts);        
       }

     case DoubleNode(v, t1, t2) =>
        assert serialise(t2) + serialise(t1) + [ CDNd(v) ] + cs == serialise(t2) + (serialise(t1) + [ CDNd(v) ] + cs);
        assert serialise(t1) + [ CSNd(v) ] + cs == serialise(t1) + ([ CSNd(v) ] + cs);
        assert serialise(t1) + [CDNd(v)] + cs == serialise(t1) + ([ CDNd(v) ] + cs);
        assert serialise(SingleNode(v,t)) == (serialise(t) + [CSNd(v)]);
        assert  [ t1 ] + ([ t2 ] + ts) == [ t1, t2] + ts;
      // Inductive case for DoubleNode
      calc {
        deserialiseAux(serialise(t) + cs, ts); 
          ==
            deserialiseAux(serialise(t2) + serialise(t1) + [ CDNd(v) ] + cs, ts);
          == 
            deserialiseAux(serialise(t2) + (serialise(t1) + [ CDNd(v) ] + cs), ts);
          == { SerialiseLemmaAux(t2, serialise(t1) + [ CDNd(v) ], ts); }
            deserialiseAux(serialise(t1) + [CDNd(v)] + cs, [ t2 ] + ts);
          == 
            deserialiseAux(serialise(t1) + ([CDNd(v)] + cs), [ t2 ] + ts);
          == { SerialiseLemmaAux(t1, [ CDNd(v) ] + cs, [ t2 ] + ts); }
            deserialiseAux([ CDNd(v) ] + cs, [ t1 ] + ([ t2 ] + ts));
          == 
            deserialiseAux([ CDNd(v) ] + cs, [ t1, t2] + ts);
          ==
            deserialiseAux(cs, deserialiseAux2(CDNd(v), [ t1, t2 ] + ts));
          == 
            deserialiseAux(cs, [ DoubleNode(v,t1, t2) ] + ts); 
          == 
            deserialiseAux(cs, [ t ] + ts);
      }
  }
}


lemma deserialiseAfterSerialiseLemma<T> (t : Tree<T>) 
ensures deserialise(serialise(t)) == [ t ]
{
   assert serialise(t) + [] == serialise(t);
  calc {
    deserialise(serialise(t));
      ==
        deserialiseAux(serialise(t) + [], []);
      == { SerialiseLemmaAux(t, [], []); }     
        deserialiseAux([], [t]); 
      ==
        [t];
      
  }
} 


method Main() {
  // Tests
  TestSerialise();
  TestDeserialise();
}








