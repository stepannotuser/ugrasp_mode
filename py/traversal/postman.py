"""Directed Chinese Postman Problem (DCPP).

Адаптация алгоритма Edmonds-Johnson на основе стандартных функций networkx:
  - nx.min_cost_flow — выравнивание дисбалансов степеней
  - nx.eulerian_circuit — эйлеров цикл в мультиграфе

Логика (дисбалансы, flow, дублирование рёбер) заимствована из класса
ChinesePostmanCollector проекта Automata Learning Lab (Saarland University).

Адаптировано под формат ugrasp: dict {state: [next_state, ...]}.
"""

import networkx as nx


def _to_nx_multidigraph(graph):
    G = nx.MultiDiGraph()
    for u in graph:
        G.add_node(u)
        for v in graph[u]:
            G.add_edge(u, v)
    return G


def _edges_to_walk(edges, start):
    if not edges:
        return [start]
    walk = [start]
    for _, v in edges:
        walk.append(v)
    return walk


def directed_chinese_postman(graph, start):
    """Кратчайший walk, покрывающий все рёбра графа (Directed CPP).

    graph: dict {state: [next_state, ...]}
    start: начальное состояние

    Raises:
        ValueError: если граф не сильно связный.
    """
    G = _to_nx_multidigraph(graph)

    # 1. Проверка сильной связности
    if not nx.is_strongly_connected(G):
        raise ValueError(
            "Graph is not strongly connected — Directed CPP неразрешима"
        )

    # 2. Дисбалансы степеней: delta(v) = out(v) - in(v)
    imbalances = {v: G.out_degree(v) - G.in_degree(v) for v in G.nodes()}

    # 3. Уже эйлеров?
    if all(d == 0 for d in imbalances.values()):
        edges = list(nx.eulerian_circuit(G, source=start))
        return _edges_to_walk(edges, start)

    # 4. Flow-сеть: те же узлы с demand = delta(v).
    #    demand > 0 → узел хочет ПОЛУЧАТЬ flow (нужны входящие рёбра)
    #    demand < 0 → узел хочет ОТПРАВЛЯТЬ flow (нужны исходящие рёбра)
    F = nx.DiGraph()
    for v in G.nodes():
        F.add_node(v, demand=imbalances[v])

    INF = 10 ** 9
    for u in G.nodes():
        for v in G.nodes():
            if u == v:
                continue
            try:
                d = nx.shortest_path_length(G, u, v)
            except nx.NetworkXNoPath:
                continue
            if d > 0:
                F.add_edge(u, v, capacity=INF, weight=d)

    # 5. Min-cost flow: находим, сколько «единиц» путей дублировать
    flow = nx.min_cost_flow(F)

    # 6. Дублируем кратчайшие пути для каждой единицы flow
    for u in G.nodes():
        for v, k in flow.get(u, {}).items():
            if k <= 0:
                continue
            path = nx.shortest_path(G, u, v)
            for _ in range(k):
                for i in range(len(path) - 1):
                    G.add_edge(path[i], path[i + 1])

    # 7. Контроль: все степени сбалансированы
    for v in G.nodes():
        if G.out_degree(v) != G.in_degree(v):
            raise RuntimeError(
                f"Vertex {v} unbalanced after duplication: "
                f"out={G.out_degree(v)} in={G.in_degree(v)}"
            )

    # 8. Эйлеров цикл
    edges = list(nx.eulerian_circuit(G, source=start))
    return _edges_to_walk(edges, start)
