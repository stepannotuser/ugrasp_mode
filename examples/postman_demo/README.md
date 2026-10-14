сравнение edge (состояния, количество переходов не оптимально), dfs (все переходы), postman (оптимальный маршрут ориентированного графа)

граф:
state,next_state
A,B
B,C
B,E
C,D
C,F
D,A
E,B
F,C
(см рисунок demo.png)

6 состояний, 8 переходов

из корня запустим 
python3 -c "
from py.parsers.csv_parser import csv_parser
from py.traversal.edges import edge_coverage_walk
from py.traversal.dfs import dfs_states
from py.traversal.postman import directed_chinese_postman
from py.traversal.common import all_edges, edges_in_walk

p = csv_parser()
g = p.read('examples/postman_demo/demo.csv')
all_e = all_edges(g)

for name, walk in [
    ('dfs',     dfs_states(g, 'A')),
    ('edges',   edge_coverage_walk(g, 'A')),
    ('postman', directed_chinese_postman(g, 'A')),
]:
    cov = len(edges_in_walk(walk, g))
    print(f'{name:8s}  {len(walk)-1:3d} transitions, покрыто {cov}/{len(all_e)}')
    print(f'         walk: {\" -> \".join(walk)}')
    print()
"

три варианта, выведем количество переходов для каждого:
dfs        12 transitions, покрыто 7/8
         walk: A -> B -> C -> D -> A -> B -> C -> F -> C -> D -> A -> B -> E

edges      10 transitions, покрыто 8/8
         walk: A -> B -> C -> D -> A -> B -> E -> B -> C -> F -> C

postman     8 transitions, покрыто 8/8
         walk: A -> B -> E -> B -> C -> F -> C -> D -> A

проанализируем:
dfs - максимальное количество переходов, неполное покрытие переходов (возврат в начальное состояние)
edges - среднее количество переходов, полное покрытие переходов
postman (почтальон для ориентированного автомата) - минимальное количество переходов, полное прокрытие переходов

