# gpt-model.sh: the GPT model and reasoning effort for every Codex run these skills make.
# Adapted from the orchestration behind Gryter (gryter.com), an AI fitness coach built by one engineer.
#
# Commands source this file and pass the values to codex; none names a model itself.
# When a new model is released, these two lines are the whole change.
#
# The values below are defaults. Update them to the strongest model and the
# highest reasoning effort your Codex CLI and your plan offer, and keep them
# current: a reviewer is only worth as much as the model behind it.

# Reviews (plan, implementation and UX) and the explorer.
export ORCH_GPT_MODEL="gpt-6.1-sol"
export ORCH_GPT_EFFORT="xhigh"
