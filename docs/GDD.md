# Game Design Doc (Living)

## Working title
Rod and Order: PLC Unit

## Core loop (A + C)
1. Alarm appears (symptom)
2. Player travels to area
3. Inspect signals (tags, trends, IO states)
4. Perform action or minigame
5. Validate fix (test run)
6. Score changes (downtime cost, safety, operator patience)

## Player fantasy
You are the calm brain in a loud hot place. Everything is vibrating. Everyone wants answers now.

## The Vertical Slice (v0.1)
### Map
One small “cell”:
- Infeed conveyor
- Photoeye (digital input)
- Motor starter (output)
- HMI panel (UI station)
- Optional: analog “speed feedback” signal

### Faults (3)
1. Stuck sensor (photoeye always ON)
2. Jam (conveyor “runs” but product doesn’t move)
3. Noisy analog signal (speed feedback spikes causing nuisance trips)

### Minigame (1)
**PID Tuner Lite**
- Adjust P and I sliders
- Watch a trend line settle
- Goal: reach setpoint quickly without overshoot

### Score
- Downtime cost ($/min)
- Safety score (penalize unsafe resets)
- Operator patience (goes down with repeated wrong actions)

## Controls
- PC: WASD/Arrow keys + interact key + mouse UI
- Mobile: joystick + big interact button + tap UI

## Style
- 2D industrial cartoon-realism
- UI feels like a playful HMI: clean boxes, clear icons, satisfying “ACK” clicks
