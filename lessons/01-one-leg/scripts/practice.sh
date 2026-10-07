#!/usr/bin/env bash
set -euo pipefail
LESSON_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$LESSON_ROOT"
PYTHON_BIN="${MEROEDU_PYTHON:-$LESSON_ROOT/.venv/bin/python}"
export MUJOCO_GL=egl
case "${1:-}" in
  reference)
    "$PYTHON_BIN" scripts/one_leg_text_reference.py --source data/kimodo_text_oneleg/oneleg_text_00_mujoco_rest_zero.csv --request data/kimodo_text_oneleg/request.json --lift-scale 2.8 --output runs/reference
    ;;
  smoke)
    "$PYTHON_BIN" scripts/one_leg_run.py train --reference runs/reference/reference.json --output runs/smoke --iterations 1 --n 2 --seed 731 --device cpu --transition
    ;;
  initialize)
    "$PYTHON_BIN" scripts/initialize_policy.py
    ;;
  train|gpu)
    "$PYTHON_BIN" scripts/one_leg_warp_run.py train --checkpoint runs/initializer/policy_initial.pt --reference runs/reference/reference.json --output runs/gpu --iterations 400 --n 64 --seed 75401 --push 0 --learning-rate .0001
    ;;
  evaluate)
    "$PYTHON_BIN" scripts/one_leg_warp_run.py evaluate --checkpoint runs/gpu/policy_final.pt --reference runs/reference/reference.json --output runs/eval-gpu --n 64 --seed 75501 --duration 18 --push 0
    "$PYTHON_BIN" scripts/one_leg_run.py evaluate --checkpoint runs/gpu/policy_final.pt --reference runs/reference/reference.json --output runs/eval-native --n 64 --seed 75501 --duration 18 --transition --push 0
    ;;
  *) echo 'Usage: bash scripts/practice.sh {reference|smoke|initialize|train|evaluate}' >&2; exit 1 ;;
esac
