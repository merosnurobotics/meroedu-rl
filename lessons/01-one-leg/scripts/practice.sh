#!/usr/bin/env bash
set -euo pipefail
LESSON_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$LESSON_ROOT"
PYTHON_BIN="${MEROEDU_PYTHON:-$LESSON_ROOT/.venv/bin/python}"
export MUJOCO_GL=egl
case "${1:-}" in
  reference)
    "$PYTHON_BIN" scripts/one_leg_text_reference.py --source data/kimodo_text_oneleg/oneleg_text_00.csv --request data/kimodo_text_oneleg/request.json --output runs/reference
    ;;
  smoke)
    "$PYTHON_BIN" scripts/one_leg_run.py train --reference runs/reference/reference.json --output runs/smoke --iterations 1 --n 2 --seed 731 --device cpu --transition
    ;;
  train)
    "$PYTHON_BIN" scripts/one_leg_run.py train --reference runs/reference/reference.json --output runs/native --iterations 460 --n 64 --seed 731 --device cpu --transition
    ;;
  gpu)
    "$PYTHON_BIN" scripts/one_leg_warp_run.py train --checkpoint runs/native/policy_final.pt --reference runs/reference/reference.json --output runs/gpu --iterations 120 --n 64 --seed 74101 --push 1
    ;;
  evaluate)
    "$PYTHON_BIN" scripts/one_leg_run.py evaluate --checkpoint runs/native/policy_final.pt --reference runs/reference/reference.json --output runs/eval-native --n 64 --seed 74201 --duration 18 --transition --push 1 --push-mode random --push-jitter .7
    ;;
  *) echo 'Usage: bash scripts/practice.sh {reference|smoke|train|gpu|evaluate}' >&2; exit 1 ;;
esac
