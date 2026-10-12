from py.traversal.common import bfs_path


def dfs_states(graph, start):
    visited, walk = set(), [start]

    def dfs(u):
        visited.add(u)
        for v in graph.get(u, []):
            if v not in visited:
                if walk[-1] != u:
                    p = bfs_path(graph, walk[-1], u)
                    if p:
                        walk.extend(p[1:])
                walk.append(v)
                dfs(v)

    dfs(start)
    return walk
