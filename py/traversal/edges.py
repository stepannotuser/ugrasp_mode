from py.traversal.common import bfs_path, all_edges


def edge_coverage_walk(graph, start):
    all_e = all_edges(graph)
    covered = set()
    walk = [start]

    while covered != all_e:
        remaining = all_e - covered
        current = walk[-1]
        best = None
        for (u, v) in sorted(remaining):
            p = bfs_path(graph, current, u)
            if p is None:
                continue
            full = p + [v]
            if best is None or len(full) < len(best[0]):
                best = (full, u, v)
        if best is None:
            break
        full, u, v = best
        walk.extend(full[1:])
        covered.add((u, v))

    return walk
