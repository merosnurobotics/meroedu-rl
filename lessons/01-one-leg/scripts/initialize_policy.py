"""Recreate the fresh seed-731 analytical-feedback + residual initializer."""
from pathlib import Path
import sys
sys.path.insert(0, str(Path(__file__).resolve().parents[1] / 'src'))
import torch
from microban_rl.one_leg import ActorCritic, save_checkpoint
root = Path(__file__).resolve().parents[1]
reference = root / 'runs/reference/reference.json'
output = root / 'runs/initializer/policy_initial.pt'
if output.exists():
    raise FileExistsError(output)
torch.manual_seed(731)
policy = ActorCritic()
with torch.no_grad():
    policy.balance.weight[8, 38] = 4.
    policy.balance.weight[8, 42] = .8
    policy.balance.weight[9, 39] = -8.
    policy.balance.weight[9, 41] = 1.6
    for i in range(19):
        policy.balance.weight[i, i] = -4.
    policy.balance.weight[18, 49] = -2.
output.parent.mkdir(parents=True, exist_ok=True)
save_checkpoint(output, policy, reference, 0, 0, {'transition': True, 'initialization_only': True, 'seed': 731, 'centering_height_feedback_coefficient': -2.})
print(output)
