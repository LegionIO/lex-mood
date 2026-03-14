# lex-mood

Persistent mood state for LegionIO agents. Part of the LegionIO cognitive architecture extension ecosystem (LEX).

## What It Does

`lex-mood` models the agent's sustained background affect — distinct from acute emotion. Where emotion is a reactive signal spike, mood is a slow-moving four-dimensional state (valence, arousal, energy, stability) updated via EMA. The current mood classification (one of nine states) emits modulation values that bias attention, risk tolerance, and curiosity across the cognitive architecture.

Key capabilities:

- **Nine mood states**: serene, content, curious, energized, anxious, frustrated, melancholic, flat, neutral
- **Four dimensions**: valence, arousal, energy, stability — all EMA-smoothed
- **Inertia**: each mood has a resistance coefficient preventing rapid oscillation
- **Modulations**: per-mood attention_threshold, risk_tolerance, and curiosity_boost values
- **Mood trend**: improving / stable / declining based on recent history

## Installation

Add to your Gemfile:

```ruby
gem 'lex-mood'
```

Or install directly:

```
gem install lex-mood
```

## Usage

```ruby
require 'legion/extensions/mood'

client = Legion::Extensions::Mood::Client.new

# Update mood from tick results
result = client.update_mood(tick_results: tick_phase_results)
# => { mood: :curious, valence: 0.62, arousal: 0.55, energy: 0.7,
#      modulations: { curiosity_boost: 0.2, attention_threshold: 0.2 } }

# Query current mood
client.current_mood
# => { mood: :curious, valence: 0.62, arousal: 0.55, energy: 0.7, stability: 0.8 }

# Query a specific modulation parameter
client.mood_modulation(parameter: :risk_tolerance)
# => { parameter: :risk_tolerance, modulation: 0.5, current_mood: :curious }

# View mood history
client.mood_history(limit: 10)

# Summary stats
client.mood_stats
# => { current_mood: :curious, dominant_mood: :content, trend: :stable, ... }
```

## Mood States and Modulations

| Mood | Attention Threshold | Risk Tolerance | Curiosity Boost |
|---|---|---|---|
| serene | 0.3 | 0.5 | 0.1 |
| content | 0.4 | 0.5 | 0.15 |
| curious | 0.2 | 0.5 | 0.2 |
| energized | 0.3 | 0.65 | 0.1 |
| anxious | 0.1 | 0.2 | 0.05 |
| frustrated | 0.5 | 0.4 | 0.05 |
| melancholic | 0.5 | 0.35 | 0.05 |
| flat | 0.6 | 0.45 | 0.02 |
| neutral | 0.4 | 0.5 | 0.1 |

## Runner Methods

| Method | Description |
|---|---|
| `update_mood` | Extract valence/arousal/energy from tick results and update state |
| `current_mood` | Current mood symbol and all dimension values |
| `mood_modulation` | Specific modulation value for the current mood |
| `mood_history` | Recent mood state history |
| `mood_stats` | Current mood, dominant mood, trend, modulation table |

## Development

```bash
bundle install
bundle exec rspec
bundle exec rubocop
```

## License

MIT
