open Ex3
open util/ordering[Id] as ord

sig ONode extends Ex3/Node {
   id: one Id
}

sig Id {
}

sig OHNode extends Ex3/HNode {
}

// fact id is unique with forall
fact IdUnique {
   always all n1, n2 : ONode | (n1 != n2) implies  n1.id != n2.id
}

fact OrderedNodes {
    always all l: OHNode, n1, n2: l.first.*(nnext) | n1 in n2.^nnext implies n1.id.gt[n2.id]
}

// Predicate to insert a node into an ordered doubly-linked list in a sorted manner
pred insertOrdered[n: ONode, hn: OHNode] {
    // Pre-conditions (specific to ordered insertion)
    all n1: ONode | n1 in (hn.first.*nnext) implies (ord/lt[n1.id, n.id] or ord/gt[n1.id, n.id])
    
    Ex3/insert[n, hn]
    
    //frame handled in Ex3
}


// Predicate to remove an ordered node from an ordered doubly-linked list
pred Oremove[n: ONode, hn: OHNode] {
    // Pre-conditions
    n in (hn.first.*nnext)
    
    Ex3/remove[n,hn]

//frame handled in Ex3
}


// TESTS ---------------------------------------------
// 4.2

run{some nnext and some nprev and all hn: OHNode
    | #hn.first.*nnext >= 2} for exactly 2 OHNode, exactly 6 ONode, exactly 6 Id, 0 Ex3/Node, 0 Ex3/HNode

// 4.4
// Test 1: Inserting a node into an empty list
run InsertOrderedIntoEmptyListTest {
    some n: ONode, hn: OHNode |
        no hn.first and no hn.last and
        insertOrdered[n, hn]
} for exactly 1 OHNode, exactly 1 ONode, exactly 1 Id, 0 Ex3/Node, 0 Ex3/HNode

// Test 2: Inserting a node at the Beginning
run InsertOrderedAtBeginningTest {
    some n: ONode, hn: OHNode, id1, id2: Id |
        hn.first.id = id1 and n.id = id2 and ord/lt[id2, id1] and
        insertOrdered[n, hn]
} for exactly 1 OHNode, exactly 2 ONode, exactly 2 Id, 0 Ex3/Node, 0 Ex3/HNode

// Test 3: Inserting a node at the End
run InsertOrderedAtEndTest {
    some n: ONode, hn: OHNode, id1, id2: Id |
        hn.last.id = id1 and n.id = id2 and ord/gt[id2, id1] and
        insertOrdered[n, hn]
} for exactly 1 OHNode, exactly 2 ONode, exactly 2 Id, 0 Ex3/Node, 0 Ex3/HNode

// Test 4: Inserting a node in the Middle   -> USED ON 4.4
run InsertOrderedInMiddleTest {
    some n: ONode, hn: OHNode, id1, id2, id3: Id |
        some n1, n2: ONode | n1 in hn.first.*(nnext) and n2 in n1.(nnext) and
        n1.id = id1 and n2.id = id2 and n.id = id3 and ord/gt[id3, id1] and ord/lt[id3, id2] and
        insertOrdered[n, hn]
} for exactly 1 OHNode, exactly 3 ONode, exactly 3 Id, 0 Ex3/Node, 0 Ex3/HNode


// Test 5: Removing a only node
run OremoveOnlyNodeTest {
    some n: ONode, hn: OHNode |
        hn.first = n and hn.last = n and
        Oremove[n, hn]
} for exactly 1 OHNode, exactly 1 ONode, exactly 1 Id, 0 Ex3/Node, 0 Ex3/HNode

// Test 6: Removing the first node
run OremoveFirstNodeTest {
    some n: ONode, hn: OHNode |
        hn.first = n and hn.last != n and
        Oremove[n, hn]
} for exactly 1 OHNode, exactly 2 ONode, exactly 2 Id, 0 Ex3/Node, 0 Ex3/HNode

// Test 7: Removing the last node
run OremoveLastNodeTest {
    some n: ONode, hn: OHNode |
        hn.last = n and hn.first != n and
        Oremove[n, hn]
} for exactly 1 OHNode, exactly 2 ONode, exactly 2 Id, 0 Ex3/Node, 0 Ex3/HNode


// Test 8: Removing a node in the middle   -> USED ON 4.4
run OremoveMiddleNodeTest {
    some n: ONode, hn: OHNode |
        n != hn.first and n != hn.last and
        Oremove[n, hn]
} for exactly 1 OHNode, exactly 3 ONode, exactly 3 Id, 0 Ex3/Node, 0 Ex3/HNode

