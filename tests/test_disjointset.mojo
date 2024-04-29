from testing import assert_equal, assert_true, assert_false

# local imports
from toybox import DisjointSet


fn test_can_init_without_size() raises:
    print("test_can_init_without_size: ", end="")
    var d = DisjointSet()
    assert_equal(len(d), 0)
    print("PASS")


fn test_can_init_with_specified_size() raises:
    print("test_can_init_with_specified_size: ", end="")
    var d = DisjointSet(100)
    assert_equal(len(d), 100)
    print("PASS")


fn test_is_valid() raises:
    print("test_is_valid: ", end="")
    var d = DisjointSet(10)
    assert_true(d.is_valid(0))
    assert_true(d.is_valid(5))
    assert_true(d.is_valid(9))
    assert_false(d.is_valid(10))
    assert_false(d.is_valid(99))
    print("PASS")


fn test_add() raises:
    print("test_add: ", end="")
    var d = DisjointSet()

    var id = d.add()
    assert_equal(id, 0)
    assert_equal(len(d), 1)

    id = d.add()
    assert_equal(id, 1)
    assert_equal(len(d), 2)

    print("PASS")


fn test_set_ids() raises:
    print("test_set_ids: ", end="")
    var d = DisjointSet(5)
    var got = d.set_ids()
    var want = List[Int](0, 1, 2, 3, 4)
    assert_equal(len(got), len(want))
    for i in range(len(got)):
        assert_equal(got[i], want[i])
    print("PASS")


fn main() raises:
    test_can_init_without_size()
    test_can_init_with_specified_size()
    test_is_valid()
    test_add()
    test_set_ids()
    print("All tests passed!")


""" TODO: convert this to Mojo

func TestDisjointSet(t *testing.T) {
    t.Run("Union", func(t *testing.T) {
        d := NewDisjointSet(5)
        assert.Equal(t, d.Len(), 5)
        var wasMerged bool

        wasMerged = d.Union(0, 1)
        assert.Equal(t, wasMerged, true)
        assert.Equal(t, d.Len(), 4)

        wasMerged = d.Union(0, 1)
        assert.Equal(t, wasMerged, false)
        assert.Equal(t, d.Len(), 4)
    })
    t.Run("Find", func(t *testing.T) {
        d := NewDisjointSet(5)
        d.Union(0, 1)
        assert.Equal(t, d.Len(), 4)
        assert.Equal(t, d.Find(0), d.Find(1))
    })
    t.Run("Find Invalid", func(t *testing.T) {
        d := NewDisjointSet(5)
        assert.Equal(t, d.Find(9), -1)
    })
    t.Run("Size", func(t *testing.T) {
        d := NewDisjointSet(5)
        d.Union(0, 1)
        assert.Equal(t, d.Len(), 4)
        assert.Equal(t, d.Size(0), 2)
    })
    t.Run("Size Invalid", func(t *testing.T) {
        d := NewDisjointSet(5)
        assert.Equal(t, d.Size(9), 0)
    })
}

// =============================================================================
// Examples

func ExampleDisjointSet() {
    d := NewDisjointSet(3)
    d.Union(0, 1) // true
    d.Union(1, 2) // true
    d.Len()       // 1
    d.Add()       // 3
    d.Add()       // 4
    d.Union(3, 4) // true
    d.Union(3, 4) // false
    d.IsValid(2)  // true
    d.IsValid(9)  // false
    d.Len()       // 2
    d.Find(0)     // 1
    d.Size(4)     // 2
    fmt.Println(d.SetIDs())
    // Output: [1 4]
}

// =============================================================================
// Benchmarks

func BenchmarkDisjointSet(b *testing.B) {
    for i := 0; i < b.N; i++ {
        d := NewDisjointSet(3)
        d.Union(0, 1)
        d.Union(1, 2)
        d.Len()
        d.Add()
        d.Add()
        d.Union(3, 4)
        d.Union(3, 4) // duplicate union; will not process
        d.IsValid(2)
        d.IsValid(9)
        d.Find(0)
        d.Size(4)
        d.SetIDs()
    }
}
"""