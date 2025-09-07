# AES_UVM_ENV

A UVM-based verification environment for AES (Advanced Encryption Standard) modules implemented in SystemVerilog/Verilog.

---

## Overview

**AES_UVM_ENV** is a modular, coverage-driven verification environment built using the Universal Verification Methodology (UVM). It is designed to verify AES encryption/decryption RTL blocks however the provided files only tests the encryption block with constrained-random and directed stimulus, functional coverage, and assertions.

---

## Repository structure

```
AES_UVM_ENV/
├── UVM/               
|   ├── pack_1/
│   |   ├── sequence_item/
│   |   ├── sequence/
│   |   ├── driver/
│   |   ├── monitor/
│   |   ├── sequencer/
│   |   ├── agent/
|   |   ├── scoreboard/
|   |   ├── subscriber/
|   |   ├── env/
│   |   └── test/
|   ├── sim_reports/
|   ├── rtl/                
|   └── tb/                
├── Python_gen/
|   └── Cipher text generation script/  
├── docs/               
├── scripts/         
└── README.md
```

## Features

- UVM-based, modular verification components
- Functional coverage (covergroups, coverpoints, cross coverage)
- Python generation script for expected cipher_text
- Example tests and sequences to exercise AES operations

---

## Quick start

### Prerequisites

- SystemVerilog simulator (e.g. Questa/ModelSim, VCS, Riviera-PRO)
- UVM library (UVM 1.1 or later)
- Python 3.x (for generation script for expected cipher_text)

## Coverage

This environment collects **functional coverage** (covergroups, coverpoints, crosses) and may collect **code coverage** (if your tool supports it).

## Contributing

Contributions are welcome. Typical PRs include:

- New tests or sequences
- Additional RTL/testbench examples
- Improved coverage and coverage reports
- CI configuration for regression runs

When opening a PR, include a brief description of changes and any simulation steps to reproduce results locally.

---

## Contact

Maintainer: [Mustafa11005] (https://github.com/Mustafa11005)

For questions or collaboration, open an Issue or reach out via GitHub.

---
