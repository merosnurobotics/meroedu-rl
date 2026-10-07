#!/usr/bin/env python3
"""Run the separate MuJoCo-Warp one-leg port; never edits native task files."""
import argparse
import json
import sys
from pathlib import Path
sys.path.insert(0, str(Path(__file__).resolve().parents[1]/'src'))
from microban_rl.one_leg_warp import evaluate, train

p = argparse.ArgumentParser()
p.add_argument('mode', choices=['evaluate', 'train'])
p.add_argument('--checkpoint', required=True)
p.add_argument('--reference')
p.add_argument('--output', required=True)
p.add_argument('--n', type=int, default=64)
p.add_argument('--seed', type=int, default=74001)
p.add_argument('--iterations', type=int, default=40)
p.add_argument('--perturb', type=float, default=.006)
p.add_argument('--duration', type=float, default=18.)
p.add_argument('--push', type=float, default=1.)
p.add_argument('--push-mode', choices=['cardinal', 'diagonal', 'random'], default='random')
p.add_argument('--push-jitter', type=float, default=.7)
p.add_argument('--learning-rate', type=float, default=3e-5)
a = p.parse_args()
if a.mode == 'evaluate':
    r = evaluate(a.checkpoint, a.output, a.reference, a.n, a.seed, a.perturb,
                 a.duration, a.push, a.push_mode, a.push_jitter)
    print(json.dumps({k: v for k, v in r.items() if k not in ('rows', 'trace_seed0', 'contract')}))
else:
    print(train(a.checkpoint, a.output, a.reference, a.iterations, a.n, a.seed,
                a.push, a.learning_rate))
