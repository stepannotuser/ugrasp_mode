from collections import deque

def bfs_path(graph, src, dst):
    if src == dst:
        return [src]
    visited, q = {src}, deque([(src, [src])])
    while q:
        u, path = q.popleft()
        for v in graph.get(u, []):
            if v == dst:
                return path + [v]
            if v not in visited:
                visited.add(v)
                q.append((v, path + [v]))
    return None


def all_edges(graph):
    return {(u, v) for u in graph for v in graph[u]}


def edges_in_walk(walk, graph):
    return {(walk[i], walk[i + 1]) for i in range(len(walk) - 1)
            if walk[i + 1] in graph.get(walk[i], [])}


def validate(walk, graph):
    return [(walk[i], walk[i + 1]) for i in range(len(walk) - 1)
            if walk[i + 1] not in graph.get(walk[i], [])]
