#!/usr/bin/env bash
# examples/demo_results.log.

set -u

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
LOG="$REPO_ROOT/examples/demo_results.log"

# Обнуляем лог
> "$LOG"

log() {
    echo "$@" | tee -a "$LOG"
}

separator() {
    log "================================================================"
}

run_step() {
    local name="$1"
    local desc="$2"
    shift 2
    separator
    log "STEP: $name"
    log "DESC: $desc"
    separator
    log ""
    "$@" 2>&1 | tee -a "$LOG"
    log ""
    log ""
}

cd "$REPO_ROOT"

log "ugrasp demonstration run"
log "Date: $(date)"
log "Branch: $(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo 'unknown')"
log "Commit: $(git rev-parse --short HEAD 2>/dev/null || echo 'unknown')"
log ""

run_step "my_fsm / random" \
    "Пример 0-get_started, случайный обход (randsequence)" \
    bash -c "cd $REPO_ROOT/examples/0-get_started && ./run.sh"

run_step "my_fsm / edges" \
    "Пример 0-get_started, автоматный обход всех переходов" \
    bash -c "cd $REPO_ROOT && ./new_code/run_automaton.sh edges"

run_step "my_fsm / dfs" \
    "Пример 0-get_started, автоматный обход всех состояний" \
    bash -c "cd $REPO_ROOT && ./new_code/run_automaton.sh dfs"

run_step "ghostsd / random" \
    "GhostSD FSM, случайный обход" \
    bash -c "cd $REPO_ROOT/examples/ghostsd && ./run_automaton.sh random"

run_step "ghostsd / edges" \
    "GhostSD FSM, автоматный обход всех переходов" \
    bash -c "cd $REPO_ROOT/examples/ghostsd && ./run_automaton.sh edges"

run_step "ghostsd / dfs" \
    "GhostSD FSM, автоматный обход всех состояний" \
    bash -c "cd $REPO_ROOT/examples/ghostsd && ./run_automaton.sh dfs"

run_step "postman_demo / анализ" \
    "Сравнение стратегий dfs/edges/postman на синтетическом графе (Python, без QuestaSim)" \
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
    print(f'{name:8s}  {len(walk)-1:3d} transitions, {cov}/{len(all_e)} edges')
    print(f'         walk: {\" -> \".join(walk)}')
    print()
"

separator
log "summary"
separator
log ""
awk '
/^STEP:/ {
    step = substr($0, 7)
    sub(/^ +/, "", step)
    sub(/ +$/, "", step)
    next
}
{
    line = $0
    sub(/^# */, "", line)
    sub(/^[0-9]+:# */, "", line)
    sub(/^ +/, "", line)
}

/\[AUTOMATON\] State coverage:/ {
    sub(/.*State coverage: */, "", line)
    printf "[%s] state coverage (auto): %s\n", step, line
    next
}
/\[AUTOMATON\] Transition coverage:/ {
    sub(/.*Transition coverage: */, "", line)
    printf "[%s] transition coverage (auto): %s\n", step, line
    next
}

/- state *coverage:/ {
    sub(/.*coverage: */, "", line)
    printf "[%s] state coverage (std):  %s\n", step, line
    next
}
/- transition coverage:/ {
    sub(/.*coverage: */, "", line)
    printf "[%s] transition coverage (std):  %s\n", step, line
    next
}

/nr of iterations/ {
    sub(/.*nr of iterations *: */, "", line)
    printf "[%s] iterations: %s\n", step, line
    next
}
/UVM_ERROR :/ {
    sub(/.*UVM_ERROR : */, "", line)
    printf "[%s] UVM_ERROR: %s\n", step, line
    next
}
/UVM_FATAL :/ {
    sub(/.*UVM_FATAL : */, "", line)
    printf "[%s] UVM_FATAL: %s\n", step, line
    next
}
/[0-9]+ transitions, [0-9]+\/[0-9]+ edges/ {
    printf "[%s] %s\n", step, line
    next
}
' "$LOG" | tee -a "$LOG"

log ""

