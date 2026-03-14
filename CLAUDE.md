# lex-mood

**Level 3 Leaf Documentation**
- **Parent**: `/Users/miverso2/rubymine/legion/extensions-agentic/CLAUDE.md`
- **Gem**: `lex-mood`
- **Version**: `0.1.0`
- **Namespace**: `Legion::Extensions::Mood`

## Purpose

Persistent mood state management for LegionIO agents. Maintains a four-dimensional mood model (valence, arousal, energy, stability) updated via EMA with per-mood inertia weighting. Classifies current mood into one of nine states and emits per-mood modulation values consumed by other subsystems (attention_threshold, risk_tolerance, curiosity_boost). Updated each tick from tick_results.

## Gem Info

- **Require path**: `legion/extensions/mood`
- **Ruby**: >= 3.4
- **License**: MIT
- **Registers with**: `Legion::Extensions::Core`

## File Structure

```
lib/legion/extensions/mood/
  version.rb
  helpers/
    constants.rb    # Mood states, dimensions, inertia, classification, modulations
    mood_state.rb   # MoodState with four-dimension EMA + classification
  runners/
    mood.rb         # Runner module

spec/
  legion/extensions/mood/
    helpers/
      constants_spec.rb
      mood_state_spec.rb
    runners/mood_spec.rb
  spec_helper.rb
```

## Key Constants

```ruby
MOOD_STATES = %i[serene content curious energized anxious frustrated melancholic flat neutral]

DIMENSIONS = %i[valence arousal energy stability]

MOOD_ALPHA       = 0.1    # EMA smoothing for dimension updates
UPDATE_INTERVAL  = 5      # minimum ticks between mood state reclassifications

MOOD_CLASSIFICATION = {
  serene:      { valence: (0.6..), arousal: (..0.4) },
  content:     { valence: (0.5..), arousal: (0.3...0.7) },
  curious:     { valence: (0.4..), arousal: (0.4...0.8), energy: (0.5..) },
  energized:   { valence: (0.5..), arousal: (0.7..) },
  anxious:     { valence: (..0.4), arousal: (0.7..) },
  frustrated:  { valence: (..0.45), arousal: (0.5...0.8) },
  melancholic: { valence: (..0.4), arousal: (..0.4) },
  flat:        { arousal: (..0.3), energy: (..0.3) },
  neutral:     {}  # fallback
}

MOOD_MODULATIONS = {
  serene:      { attention_threshold: 0.3, risk_tolerance: 0.5, curiosity_boost: 0.1 },
  content:     { attention_threshold: 0.4, risk_tolerance: 0.5, curiosity_boost: 0.15 },
  curious:     { attention_threshold: 0.2, risk_tolerance: 0.5, curiosity_boost: 0.2 },
  energized:   { attention_threshold: 0.3, risk_tolerance: 0.65, curiosity_boost: 0.1 },
  anxious:     { attention_threshold: 0.1, risk_tolerance: 0.2, curiosity_boost: 0.05 },
  frustrated:  { attention_threshold: 0.5, risk_tolerance: 0.4, curiosity_boost: 0.05 },
  melancholic: { attention_threshold: 0.5, risk_tolerance: 0.35, curiosity_boost: 0.05 },
  flat:        { attention_threshold: 0.6, risk_tolerance: 0.45, curiosity_boost: 0.02 },
  neutral:     { attention_threshold: 0.4, risk_tolerance: 0.5, curiosity_boost: 0.1 }
}

MOOD_INERTIA = {
  serene: 0.9, content: 0.8, curious: 0.7, energized: 0.6,
  anxious: 0.5, frustrated: 0.5, melancholic: 0.85, flat: 0.9, neutral: 0.7
}
```

## Helpers

### `Helpers::MoodState` (class)

Four-dimensional EMA mood tracker with inertia-weighted classification.

| Attribute | Type | Description |
|---|---|---|
| `valence` | Float (0..1) | positive-negative dimension |
| `arousal` | Float (0..1) | activation level |
| `energy` | Float (0..1) | resource availability |
| `stability` | Float (0..1) | variance over recent updates |

| Method | Description |
|---|---|
| `update(inputs)` | EMA-updates all four dimensions from input hash; applies inertia to current mood when reclassifying |
| `current_mood` | matches dimensions against MOOD_CLASSIFICATION conditions; returns mood symbol |
| `mood_trend` | direction of change across recent mood history (:improving / :stable / :declining) |

Update input extraction:
- `valence` from `inputs[:valence]` or `inputs[:emotional_valence]`
- `arousal` from `inputs[:arousal]` or `inputs[:emotional_arousal]`
- `energy` from `1.0 - (elapsed / budget)` from tick timing
- `stability` from variance of recent valence values

## Runners

Module: `Legion::Extensions::Mood::Runners::Mood`

Private state: `@state` (memoized `MoodState` instance).

| Runner Method | Parameters | Description |
|---|---|---|
| `update_mood` | `tick_results: {}` | Extract valence/arousal/energy from tick_results; update mood state |
| `current_mood` | (none) | Current mood symbol, all four dimension values |
| `mood_modulation` | `parameter:` | Specific modulation value for current mood |
| `mood_history` | `limit: 20` | Recent mood state history |
| `mood_stats` | (none) | Current mood, dominant mood, trend, modulation table |

`update_mood` extracts from tick_results:
- `valence` from `tick_results[:emotional_evaluation][:valence]`
- `arousal` from `tick_results[:emotional_evaluation][:arousal]`
- `energy` from tick elapsed/budget ratio (inverted: lower elapsed = higher energy)

`mood_modulation` return:
```ruby
{ parameter: :curiosity_boost, modulation: 0.2, current_mood: :curious }
```

## Integration Points

- **lex-tick**: `update_mood` is called in `emotional_evaluation` or a dedicated mood phase with tick_results.
- **lex-emotion**: emotion provides acute valence/arousal signals; mood integrates them slowly via EMA with high inertia.
- **lex-curiosity**: `curiosity_boost` from MOOD_MODULATIONS adjusts wonder formation rate in lex-curiosity.
- **lex-attention**: `attention_threshold` from MOOD_MODULATIONS sets the signal salience floor in lex-attention.
- **lex-volition / lex-imagination**: `risk_tolerance` from MOOD_MODULATIONS biases action selection toward or away from risky options.
- **lex-metacognition**: `Mood` is listed under `:perception` capability category.

## Development Notes

- Mood classification is first-match over MOOD_CLASSIFICATION conditions in definition order. `neutral` is always the fallback (empty conditions always match). The definition order therefore implicitly sets priority — `serene` has highest specificity requirements.
- `MOOD_INERTIA` determines how resistant a mood is to classification change. High-inertia moods (serene: 0.9, melancholic: 0.85) require stronger sustained dimension shifts to reclassify.
- `UPDATE_INTERVAL` prevents rapid mood oscillation — the mood state is only reclassified after 5 ticks minimum since the last change. EMA updates still occur every tick; only classification is gated.
- `stability` dimension is derived from variance of recent `valence` values, not a separate input. It is computed internally by `MoodState` from its history buffer.
- No actor; `update_mood` is driven by the tick cycle.
