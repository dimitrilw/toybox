from testing import assert_equal

# local imports
from toybox import heap

def test_heap_push_and_pop():
    var h = List[Int]()
    heap.push[Int](h, 3)
    heap.push(h, 2)
    heap.push(h, 1)
    assert_equal(len(h), 3)
    assert_equal(heap.pop(h), 1)
    assert_equal(heap.pop(h), 2)
    assert_equal(heap.pop(h), 3)
    assert_equal(len(h), 0)

def test_heap_replace():
    var h = List[Int]()
    heap.push(h, 3)
    heap.push(h, 2)
    heap.push(h, 1)
    assert_equal(len(h), 3)
    assert_equal(heap.replace(h, 0), 1)
    assert_equal(heap.replace(h, 4), 0)
    assert_equal(heap.replace(h, 5), 2)
    assert_equal(heap.replace(h, 6), 3)
    assert_equal(heap.pop(h), 4)
    assert_equal(heap.pop(h), 5)
    assert_equal(heap.pop(h), 6)
    assert_equal(len(h), 0)

def test_heap_push_pop():
    var h = List[Int]()
    heap.push(h, 3)
    heap.push(h, 2)
    heap.push(h, 1)
    assert_equal(len(h), 3)
    assert_equal(heap.push_pop(h, 0), 0)
    assert_equal(heap.push_pop(h, 4), 1)
    assert_equal(heap.push_pop(h, 5), 2)
    assert_equal(heap.push_pop(h, -1), -1)
    assert_equal(heap.pop(h), 3)
    assert_equal(heap.pop(h), 4)
    assert_equal(heap.pop(h), 5)
    assert_equal(len(h), 0)

@value
struct MaxInt(heap.HeapableCollectionElement):
    var value: Int
    fn __lt__(self, rhs: MaxInt) -> Bool:
        return self.value > rhs.value

def test_heap_max_heap():
    var h = List[MaxInt]()
    heap.push(h, MaxInt(1))
    heap.push(h, MaxInt(2))
    heap.push(h, MaxInt(3))
    assert_equal(heap.pop(h).value, 3)
    assert_equal(heap.pop(h).value, 2)
    assert_equal(heap.pop(h).value, 1)

@value
struct TestStruct(heap.HeapableCollectionElement):
    var a: Int
    var b: Int
    var s: String
    fn __lt__(self, rhs: TestStruct) -> Bool:
        if self.a == rhs.a:
            return self.b < rhs.b
        return self.a < rhs.a

def test_heap_complex_custom_structs():
    var h = List[TestStruct]()
    heap.push(h, TestStruct(3, 1, "three one"))
    heap.push(h, TestStruct(2, 1, "two one"))
    heap.push(h, TestStruct(1, 1, "one one"))
    assert_equal(heap.pop(h).s, "one one")
    heap.push(h, TestStruct(2, 2, "two two"))
    assert_equal(heap.pop(h).s, "two one")
    assert_equal(heap.pop(h).s, "two two")
    assert_equal(heap.pop(h).s, "three one")

def test_heapify():
    var h = List[Int](3, 2, 1, 4, 5)
    heap.heapify(h)
    assert_equal(len(h), 5)
    assert_equal(heap.pop(h), 1)
    assert_equal(heap.pop(h), 2)
    assert_equal(heap.pop(h), 3)
    assert_equal(heap.pop(h), 4)
    assert_equal(heap.pop(h), 5)
    assert_equal(len(h), 0)