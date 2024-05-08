# toybox

Various data-structures and other toys implemented in Mojo🔥.

![Mojo Nightly 2024.4.2414](https://img.shields.io/badge/Mojo%F0%9F%94%A5-Nightly_2024.4.2414-purple)

![Mojo data structures](etc/toybox.png)

## package

1. Clone repo & cd into it.
2. Run: `mojo package toybox/toybox -o /path/to/your/packages/toybox.mojopkg`

## toys

### disjoint set

aka "union find", aka "merge find", aka "merge set", aka "disjoint set union (DSU)"

```mojo
from toybox import DisjointSet
```

## example use

See the tests directory. While files like `test_disjointset.mojo` are just testing
the DisjointSet implementation, files like `test_disjointset_example_kruskal_mst.mojo`
provide an example use.

## external dependencies

Until Mojo has a package manager, this repository notes dependencies here.

### quicksort.📦

Source: https://github.com/mzaks/mojo-sort/tree/5b2aa6b436908ca5fde9a3f2787c6892a4fe1112/quick_sort
