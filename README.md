# lex-mood

Persistent mood state for the LegionIO brain-modeled agentic architecture.

Mood is distinct from emotion. Emotion is acute and reactive — a signal triggers a valence. Mood is chronic and sustained — it emerges from patterns of emotion, energy, and stability, and biases all cognitive processing. An anxious agent perceives more threats. A curious agent explores more. A flat agent conserves energy.

## Mood States

| Mood | Valence | Arousal | Effect |
|------|---------|---------|--------|
| serene | high | low | Broad attention, moderate risk tolerance |
| content | high | medium | Balanced, slight curiosity boost |
| curious | positive | medium-high | Lower attention threshold, exploration boost |
| energized | positive | high | Action-biased, higher risk tolerance |
| anxious | low | high | Hypervigilant, risk-averse |
| frustrated | negative | medium-high | Narrow focus, reduced curiosity |
| melancholic | negative | low | High inertia, reduced drive |
| flat | neutral | low | Energy conservation, minimal engagement |
| neutral | balanced | balanced | No modulation biases |

## Usage

```ruby
client = Legion::Extensions::Mood::Client.new

# Feed tick results each tick
result = client.update_mood(tick_results: tick_phase_results)
# => { mood: :curious, valence: 0.62, arousal: 0.55, modulations: { curiosity_boost: 0.2, ... } }

# Query current mood modulation for a parameter
client.mood_modulation(parameter: :curiosity_boost)
# => { parameter: :curiosity_boost, modulation: 0.2, current_mood: :curious }

# View mood history and trends
client.mood_stats
# => { current_mood: :curious, dominant_mood: :content, trend: :improving, ... }
```

## License

MIT
