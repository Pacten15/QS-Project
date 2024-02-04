function sorted(s : seq<int>) : bool {
  forall k1, k2 :: 0 <= k1 <= k2 < |s| ==> s[k1] <= s[k2]
}


// Ex1
method copy(a : array<int>, l : int, r : int) returns (ret : array<int>)
  requires 0 <= l < r <= a.Length 
  ensures ret[..] == a[l..r]
{
  ret := new int[r-l]; 
  var i := l;
  var j := 0;
  while (i < r)
  invariant 0 <= j <= i - l
  invariant l <= i <= r
  invariant ret[..j] == a[l..i]
  {
    ret[j] := a[i];
    i := i + 1;
    j := j + 1;
  }
}



// Ex2
method mergeArr(a : array<int>, l : int, m : int, r : int)
  requires 0 <= l < m < r <= a.Length
  requires sorted(a[l..m]) && sorted(a[m..r])
  ensures sorted(a[l..r])
  ensures a[..l] == old(a[..l])
  ensures a[r..] == old(a[r..])
  modifies a
{

  print "Copying arrays...\n";
  var L := copy(a, l, m);
  var R := copy(a, m, r);

  print "Left array: ";
  printArray(L);
  print "Right array: ";
  printArray(R);

  var n1 := L.Length;  // Tamanho do left
  var n2 := R.Length;  // Tamanho do right

  var i, j, k := 0, 0, l;


  // Merge os dois sorted arrays
  while (i < n1 || j < n2)
    invariant 0 <= i <= n1
    invariant 0 <= j <= n2
    invariant k == l + i + j
    invariant l <= k <= r
    invariant sorted(L[..]) && sorted(R[..])
    invariant (i < n1 && k-1>=l) ==> a[k-1] <= L[i]
    invariant (j < n2 && k-1>=l) ==> a[k-1] <= R[j]
    invariant sorted(a[l..k])
    invariant a[..l] == old(a[..l])
    invariant a[r..] == old(a[r..])
    decreases n1 - i, n2 - j
  {
    if (i < n1 && (j >= n2 || L[i] <= R[j])) {
      a[k] := L[i];
      i := i + 1;
    } else {
      a[k] := R[j];
      j := j + 1;
    }
    k := k + 1;
  }
}

//ex3
method mergeSort(a : array<int>) 
  ensures sorted(a[..])
  modifies a
{
  mergeSortAux(a, 0, a.Length);
  assert sorted(a[..]);
}




method mergeSortAux(a: array<int>, l: int, r: int)
  requires 0 <= l <= r <= a.Length
  ensures sorted(a[l..r])
  ensures a[..l] == old(a[..l])
  ensures a[r..] == old(a[r..])
  decreases r - l
  modifies a
{
  if (r - l >= 2) 
  {
    var m := l + (r - l) / 2;
    mergeSortAux(a, l, m);
    mergeSortAux(a, m, r);
    mergeArr(a, l, m, r);

  }
}
 

method Main() 
{
  var a := new int[8];
  a[0] := 2;
  a[1] := 4;
  a[2] := 6;
  a[3] := 8;
  a[4] := 1;
  a[5] := 3;
  a[6] := 5;
  a[7] := 7;

  print "Initial array: ";
  printArray(a);

  // Testing mergeArr
  mergeArr(a, 0, 4, 8); // This will merge the two halves, [2, 4, 6, 8] and [1, 3, 5, 7]

  print "After merge: ";
  printArray(a);
  
}

method printArray(a: array<int>)
{
  var i := 0;
  while (i < a.Length)
    invariant 0 <= i <= a.Length
  {
    print a[i], " ";
    i := i + 1;
  }
  print "\n";
}



