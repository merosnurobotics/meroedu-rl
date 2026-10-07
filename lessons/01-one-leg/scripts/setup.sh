#!/usr/bin/env bash
# Run from lessons/01-one-leg. Fetch only the model source required by this lesson.
set -euo pipefail
LESSON_ROOT="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/.." && pwd -P)"
cd "$LESSON_ROOT"
command -v git >/dev/null
command -v python3.12 >/dev/null
MODEL_COMMIT=d594a6088bb7b6600fe8098321169031fbca680c
MODEL_DIR=vendor/mjlab_microban
if [[ ! -e "$MODEL_DIR" ]]; then
  mkdir -p vendor
  git clone --filter=blob:none --no-checkout https://github.com/Rhoban/mjlab_microban.git "$MODEL_DIR"
  git -C "$MODEL_DIR" fetch --depth 1 origin "$MODEL_COMMIT"
  git -C "$MODEL_DIR" checkout --detach "$MODEL_COMMIT"
fi
[[ "$(git -C "$MODEL_DIR" rev-parse HEAD)" == "$MODEL_COMMIT" ]] || { echo 'Model revision mismatch; existing checkout preserved.' >&2; exit 1; }
python3.12 -m venv .venv
.venv/bin/python -m pip install --upgrade pip
if [[ "${1:-cpu}" == gpu ]]; then
  .venv/bin/python -m pip install torch==2.7.0 --index-url https://download.pytorch.org/whl/cu128
  .venv/bin/python -m pip install -r requirements-gpu.txt
elif [[ "${1:-cpu}" == cpu ]]; then
  .venv/bin/python -m pip install torch==2.7.0 --index-url https://download.pytorch.org/whl/cpu
  .venv/bin/python -m pip install -r requirements.txt
else
  echo 'Usage: bash scripts/setup.sh [cpu|gpu]' >&2; exit 1
fi
.venv/bin/python scripts/prepare_model.py
echo 'Ready. Run: source .venv/bin/activate'
