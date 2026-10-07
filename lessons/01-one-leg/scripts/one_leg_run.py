from pathlib import Path
import argparse
import sys
sys.path.insert(0,str(Path(__file__).resolve().parents[1]/'src'))
from microban_rl.one_leg import train,evaluate,render

p=argparse.ArgumentParser();p.add_argument('mode',choices=['train','evaluate','render']);p.add_argument('--reference');p.add_argument('--checkpoint');p.add_argument('--output',required=True);p.add_argument('--iterations',type=int,default=200);p.add_argument('--n',type=int,default=64);p.add_argument('--seed',type=int,default=42);p.add_argument('--perturb',type=float,default=.01);p.add_argument('--duration',type=float,default=15);p.add_argument('--transition',action='store_true');p.add_argument('--device',default='cpu');p.add_argument('--push',type=float,default=0.);p.add_argument('--push-mode',choices=['cardinal','diagonal','random'],default='cardinal');p.add_argument('--push-jitter',type=float,default=.3);a=p.parse_args()
if a.mode=='train':print(train(a.reference,a.output,a.iterations,a.n,a.seed,a.device,a.checkpoint,a.transition,a.push))
elif a.mode=='evaluate':
 r=evaluate(a.checkpoint,a.output,a.n,a.seed,a.perturb,a.duration,a.transition,a.reference,a.push,a.push_mode,a.push_jitter);print({k:v for k,v in r.items() if k not in ['rows','trace_seed0','manifest']})
else:print(render(a.checkpoint,a.output,a.seed,a.duration,a.perturb,a.transition,a.reference,a.push)['video'])
