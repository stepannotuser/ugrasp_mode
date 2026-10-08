#!/usr/bin/env python3

import csv
import sys
from collections import deque


def read_graph(filename):
    db = {}
    with open(filename, 'r') as f:
        rows = list(csv.reader(f))

    header = [c.lower().strip() for c in rows[0]]
    si = header.index('state') if 'state' in header else 0
    ni = header.index('next_state') if 'next_state' in header else 1

    for row in rows[1:]:
        if len(row) <= max(si, ni):
            continue
        s = row[si].strip()
        n = row[ni].strip()
        if not s or not n:
            continue
        db.setdefault(s, [])
        db.setdefault(n, [])
        if n not in db[s]:
            db[s].append(n)
    return db


def bfs_path(graph, src, dst):
    if src == dst:
        return [src]
    visited = {src}
    q = deque([(src, [src])])
    while q:
        u, path = q.popleft()
        for v in graph.get(u, []):
            if v == dst:
                return path + [v]
            if v not in visited:
                visited.add(v)
                q.append((v, path + [v]))
    return None


def dfs_states(graph, start):
    visited = set()
    walk = [start]

    def dfs(u):
        visited.add(u)
        for v in graph.get(u, []):
            if v not in visited:
                # ->u
                if walk[-1] != u:
                    p = bfs_path(graph, walk[-1], u)
                    if p is not None:
                        walk.extend(p[1:])
                # u->v
                walk.append(v)
                dfs(v)

    dfs(start)
    return walk


def all_edges(graph):
    return {(u, v) for u in graph for v in graph[u]}


def edges_in_walk(walk, graph):
    return {(walk[i], walk[i + 1]) for i in range(len(walk) - 1)
            if walk[i + 1] in graph.get(walk[i], [])}


def edge_coverage_walk(graph, start):
    all_e = all_edges(graph)
    covered = set()
    walk = [start]

    while covered != all_e:
        remaining = all_e - covered
        current = walk[-1]
        best = None
        for (u, v) in remaining:
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


def validate(walk, graph):
    bad = []
    for i in range(len(walk) - 1):
        u, v = walk[i], walk[i + 1]
        if v not in graph.get(u, []):
            bad.append((u, v))
    return bad


def report(walk, graph, mode):
    all_e = all_edges(graph)
    cov_e = edges_in_walk(walk, graph)
    cov_s = set(walk)
    bad = validate(walk, graph)

    print(f"Mode:   {mode}")
    print(f"States: {len(cov_s)}/{len(graph)}")
    print(f"Edges:  {len(cov_e)}/{len(all_e)}")
    print(f"Walk:   {len(walk)} states, {len(walk) - 1} transitions")
    if bad:
        print(f"НЕВАЛИДНЫХ переходов: {len(bad)}")
        for e in bad:
            print(f"    {e[0]} -> {e[1]}")
    print()
    print("Walk:")
    print(" -> ".join(walk))
    print()

    missing = all_e - cov_e
    if missing:
        print("Непокрытые рёбра:")
        for u, v in sorted(missing):
            print(f"  {u} -> {v}")
    else:
        print("Все рёбра покрыты.")


def main():
    if len(sys.argv) < 3:
        print("Usage: dfs_traversal.py <graph.csv> <dfs|edges> [start_state]")
        sys.exit(1)

    csv_file, mode = sys.argv[1], sys.argv[2]
    graph = read_graph(csv_file)
    start = sys.argv[3] if len(sys.argv) > 3 else next(iter(graph))

    print(f"Graph: {len(graph)} states, {len(all_edges(graph))} edges")
    print(f"Start: {start}")
    print()

    if mode == 'dfs':
        walk = dfs_states(graph, start)
    elif mode == 'edges':
        walk = edge_coverage_walk(graph, start)
    else:
        print(f"Unknown mode: {mode}")
        sys.exit(1)

    report(walk, graph, mode)


if __name__ == '__main__':
    main()
