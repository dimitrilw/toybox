# toybox

Various data-structures and other toys implemented in Mojo🔥.

![Mojo Nightly 2024.5.822](https://img.shields.io/badge/Mojo%F0%9F%94%A5-Nightly_2024.5.822-purple)

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

Until Mojo has a mature package manager, this repository keeps dependencies in
the `external/` directory.
