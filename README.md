# toybox

Various data-structures and other toys implemented in Mojo🔥.

![Mojo Nightly 2024.4.2414](https://img.shields.io/badge/Mojo%F0%9F%94%A5-Nightly_2024.4.2414-purple)

![Mojo data structures](etc/toybox.png)

## package

1. Clone repo & cd into it.
2. Run: `mojo package toybox/toybox -o /path/to/your/packages/toybox.mojopkg`

## disjoint set

aka "union find", aka "merge find", aka "merge set", aka "disjoint set union (DSU)"

```mojo
from toybox import DisjointSet
```
