sig Node {
    var nprev: lone Node,
    var nnext: lone Node
}

sig HNode {
    var first: lone Node,  
    var last: lone Node   
}


// The first node does not have a previous node, and the last node does not have a next node
fact FirstLastNodes {
    always all l: HNode | no l.first.nprev and no l.last.nnext
}

// Node is either free or in a list
fact SingleDLLorFree {
   always all n: Node | 
        lone l: HNode | 
            n in (l.first + l.first.*nnext + l.last + l.last.*nprev)
}

// No node is its own next or previous node
fact NoSelfPointing {
   always  no n: Node | n = n.nnext or n = n.nprev
}

// Consistency of Connections
fact ConsistencyOfConnections {
   always all n1, n2 : Node | (n1 in n2.^nnext implies n2 in n1.^nprev) and (n1 in n2.^nprev implies n2 in n1.^nnext)
}

// Free nodes should not be connected to any other node
fact FreeNodesAreLone {
    always all n: Node | (no l: HNode | n = l.first or n in l.first.^nnext or n = l.last or n in l.last.^nprev) implies (no n.nnext and no n.nprev)
}

// Nodes inside of a list are connected to each other
fact NodesAreConnected {
   always all l: HNode | l.last in l.first.*nnext and l.first in l.last.*nprev
}


pred insert[n: Node, hn: HNode] {
    // Case 1: Insert in an empty list
    (no hn.first and no hn.last and
     no n.nprev and no n.nnext and
     hn.first' = n and
     hn.last' = n and
     n.nnext' = none and
     n.nprev' = none) or

    // Case 2: Insert at the beginning of a non-empty list
    (some hn.first and
     no n.nprev and no n.nnext and
     hn.first.nprev' = n and
     n.nnext' = hn.first and
     hn.first' = n) or

    // Case 3: Insert at the end of a non-empty list
    (some hn.last and
     no n.nprev and no n.nnext and
     hn.last.nnext' = n and
     hn.last' = n and
     n.nprev' = hn.last) or

    // Case 4: Insert in the middle of a non-empty list
    (some nd: hn.last.^nprev |
     some nd.nnext and
     no n.nprev and no n.nnext and
     n.nnext' = nd.nnext and
     n.nprev' = nd and
     nd.nnext.nprev' = n and
     nd.nnext' = n)

    // Frame conditions
    all hn1: HNode | (hn1 != hn) implies hn1.first' = hn1.first && hn1.last' = hn1.last
    all n1: Node | (n1 != n && ((n != hn.first => n1 != hn.first) && (n != hn.last => n1 != hn.last))) implies n1.nnext' = n1.nnext && n1.nprev' = n1.nprev
}


pred RemoveOnlyNode[n: Node, hn: HNode] {
    // Pre-conditions
    hn.first = n and hn.last = n

    // Post-conditions
    hn.first' = none
    hn.last' = none
    n.nnext' = none
    n.nprev' = none

    // Frame conditions
    all hn1: HNode | (hn1 != hn) implies hn1.first' = hn1.first && hn1.last' = hn1.last
    all n1: Node | (n1 != n) implies n1.nnext' = n1.nnext && n1.nprev' = n1.nprev
}

pred RemoveFirstNode[n: Node, hn: HNode] {
    // Pre-conditions
    hn.first = n and hn.last != n

    // Post-conditions
    hn.first' = n.nnext
    n.nnext.nprev' = none
    n.nnext' = none
    n.nprev' = none

    // Frame conditions
    all hn1: HNode | (hn1 != hn) implies hn1.first' = hn1.first && hn1.last' = hn1.last
    all n1: Node | (n1 != n && n1 != n.nnext) implies n1.nnext' = n1.nnext && n1.nprev' = n1.nprev
}

pred RemoveLastNode[n: Node, hn: HNode] {
    // Pre-conditions
    hn.last = n and hn.first != n

    // Post-conditions
    hn.last' = n.nprev
    n.nprev.nnext' = none
    n.nnext' = none
    n.nprev' = none

    // Frame conditions
    all hn1: HNode | (hn1 != hn) implies hn1.first' = hn1.first && hn1.last' = hn1.last
    all n1: Node | (n1 != n && n1 != n.nprev) implies n1.nnext' = n1.nnext && n1.nprev' = n1.nprev
}

pred RemoveMiddleNode[n: Node, hn: HNode] {
    // Pre-conditions
    n != hn.first and n != hn.last

    // Post-conditions
    n.nprev.nnext' = n.nnext
    n.nnext.nprev' = n.nprev
    n.nnext' = none
    n.nprev' = none

    // Frame conditions
    all hn1: HNode | (hn1 != hn) implies hn1.first' = hn1.first && hn1.last' = hn1.last
    all n1: Node | (n1 != n && n1 != n.nprev && n1 != n.nnext) implies n1.nnext' = n1.nnext && n1.nprev' = n1.nprev
}

pred remove[n: Node, hn: HNode] {
    n in (hn.first.*nnext) and (
        RemoveOnlyNode[n, hn] or
        RemoveFirstNode[n, hn] or
        RemoveLastNode[n, hn] or
        RemoveMiddleNode[n, hn]
    )
}



//3.2 
run {some nnext && some nprev} for exactly 2 HNode, exactly 6 Node

//3.4
//empty 
run InsertInEmptyTest {
    some n: Node, hn: HNode |
        no hn.first and no hn.last and
        insert[n, hn]
} for exactly 1 HNode, exactly 1 Node

// first
run InsertFirstTest {
    some n: Node, hn: HNode |
        some hn.first and no n.nprev and no n.nnext and
        insert[n, hn]
} for exactly 1 HNode, exactly 2 Node

//last
run InsertLastTest {
    some n: Node, hn: HNode |
        some hn.last and no n.nprev and no n.nnext and
        insert[n, hn]
} for exactly 1 HNode, exactly 2 Node

//middle  -> USED ON 3.4
run InsertInMiddleTest {
    some n: Node, nd: Node, hn: HNode |
        some nd.nnext and no n.nprev and no n.nnext and
        insert[n, hn]
} for exactly 1 HNode, exactly 3 Node

// remove only node
run RemoveOnlyNodeTest {
    some n: Node, hn: HNode |
        hn.first = n and hn.last = n and
        remove[n, hn]
} for exactly 1 HNode, exactly 1 Node

// remove first node
run RemoveFirstNodeTest {
    some n: Node, hn: HNode |
        hn.first = n and hn.last != n and
        remove[n, hn]
} for exactly 1 HNode, exactly 2 Node

// remove last node
run RemoveLastNodeTest {
    some n: Node, hn: HNode |
        hn.last = n and hn.first != n and
        remove[n, hn]
} for exactly 1 HNode, exactly 2 Node

// remove middle node   -> USED ON 3.4
run RemoveMiddleNodeTest {
    some n: Node, hn: HNode |
        n != hn.first and n != hn.last and
        remove[n, hn]
} for exactly 1 HNode, exactly 3 Node




