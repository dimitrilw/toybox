""" A real-life friend asked if this HeapableCollectionElement concept makes it 
    possible to create a Heap of Heaps. I said "yes". He said "prove it." 
    And because I thought it was funny: challenge accepted.

    Why would you ever want to do this? I have no idea. But it's possible.
"""

from testing import assert_equal

# local imports
from toybox import heap

@value
struct HeapableHeap(heap.HeapableCollectionElement):
    var data: List[Int]

    fn __lt__(self, rhs: HeapableHeap) -> Bool:
        return self._sum() < rhs._sum()
    
    fn _sum(self) -> Int:
        var res = 0
        for i in self.data:
            res += i[]
        return res

    fn __len__(self) -> Int:
        return len(self.data)

def test_heap_of_heaps():
    var h1 = List[Int](3, 2, 1) # sum = 6
    heap.heapify[Int](h1)
    var hh1 = HeapableHeap(h1)

    var h2 = List[Int](6, 5, 4) # sum = 15
    heap.heapify[Int](h2)
    var hh2 = HeapableHeap(h2)

    var h3 = List[Int](9, 8, 7) # sum = 24
    heap.heapify[Int](h3)
    var hh3 = HeapableHeap(h3)

    var heap_o_heaps = List[HeapableHeap]()
    heap.push(heap_o_heaps, hh2)
    heap.push(heap_o_heaps, hh1)
    heap.push(heap_o_heaps, hh3)
    assert_equal(len(heap_o_heaps), 3)

    var popped: HeapableHeap

    popped = heap.pop(heap_o_heaps)
    assert_equal(len(heap_o_heaps), 2)
    assert_equal(len(popped), 3)
    assert_equal(popped._sum(), 6)
    assert_equal(heap.pop(popped.data), 1)
    assert_equal(heap.pop(popped.data), 2)
    assert_equal(heap.pop(popped.data), 3)
    assert_equal(len(popped), 0)

    popped = heap.pop(heap_o_heaps)
    assert_equal(len(heap_o_heaps), 1)
    assert_equal(len(popped), 3)
    assert_equal(popped._sum(), 15)
    assert_equal(heap.pop(popped.data), 4)
    assert_equal(heap.pop(popped.data), 5)
    assert_equal(heap.pop(popped.data), 6)
    assert_equal(len(popped), 0)
    heap.push(popped.data, 99) # popped now has a sum of 99
    assert_equal(len(popped), 1)
    heap.push(heap_o_heaps, popped)
    assert_equal(len(heap_o_heaps), 2)

    popped = heap.pop(heap_o_heaps)
    assert_equal(len(heap_o_heaps), 1)
    assert_equal(len(popped), 3)
    assert_equal(popped._sum(), 24)
    assert_equal(heap.pop(popped.data), 7)
    assert_equal(heap.pop(popped.data), 8)
    assert_equal(heap.pop(popped.data), 9)
    assert_equal(len(popped), 0)

    popped = heap.pop(heap_o_heaps)
    assert_equal(len(heap_o_heaps), 0)
    assert_equal(len(popped), 1)
    assert_equal(popped._sum(), 99)
    assert_equal(heap.pop(popped.data), 99)
    assert_equal(len(popped), 0)